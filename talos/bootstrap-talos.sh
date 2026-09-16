#!/bin/bash
set -o pipefail

#Set the Control Plane and Workers IPs
CONTROL_PLANE_IPS="192.168.0.200,192.168.0.201"
IFS=',' read -r -a control_plane_ips <<<"$CONTROL_PLANE_IPS"
WORKERS_IPS="192.168.0.211,192.168.0.212,192.168.0.213,192.168.0.214"
IFS=',' read -r -a workers_ips <<<"$WORKERS_IPS"

# Talos Image
TALOS_IMAGE="factory.talos.dev/nocloud-installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.14.0"

# Cluster Name
CLUSTER_NAME="hellheim"

# Disk Selecto
DISK_SELECTOR='disk.dev_path == "/dev/vda"'

init_cluster() {
  # Talos Patch to disable Flannel CNI and KubeProxy

  echo "Generando fichero patch.yaml para desactivar Flannel CNI y KubeProxy"
  sleep 1
  cat <<EOF >patch.yaml
apiVersion: v1alpha1
kind: KubeFlannelCNIConfig
\$patch: delete
---
apiVersion: v1alpha1
kind: KubeProxyConfig
enabled: false
---
apiVersion: v1alpha1
kind: UnattendedInstallConfig
installer:
    image: $TALOS_IMAGE
provisioning:
    diskSelector:
        match: $DISK_SELECTOR
    wipe: false
EOF

  echo "Generando configuracion Control Plane, Worker, Talosconfig"
  sleep 1
  talosctl gen config --config-patch-control-plane @patch.yaml "$CLUSTER_NAME" "https://${control_plane_ips[0]}:6443"

  # Applying config to Control Plane Node
  talosctl apply-config --insecure --nodes "${control_plane_ips[0]}" --file controlplane.yaml

  # Set Control Plane IP as endpoint
  talosctl --talosconfig=./talosconfig config endpoints "${control_plane_ips[0]}"

  # Sleep during cluster is rebooting
  echo "Esperando a que el nodo se reinicie"
  sleep 20

  # Bootstrapping etcd cluster
  talosctl bootstrap --nodes "${control_plane_ips[0]}" --talosconfig=./talosconfig

  # Get Kubernetes Access
  talosctl kubeconfig --nodes "${control_plane_ips[0]}" --talosconfig=./talosconfig
}

reconcile_cluster() {

  MEMBERS_IPS=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}')

  for cp in "${control_plane_ips[@]}"; do

    if [[ "$cp" == "${control_plane_ips[0]}" ]]; then
      continue
    fi

    if grep -qx "$cp" <<<"$MEMBERS_IPS"; then
      echo "${cp} ya está en el cluster"
      continue
    else
      echo "Uniendo ${cp} al cluster"
      talosctl apply-config --insecure --nodes "$cp" --file controlplane.yaml
    fi

    sleep 2
  done

  # Reconcile Workers

  for wk in "${workers_ips[@]}"; do

    if grep -qx "$wk" <<<"$MEMBERS_IPS"; then
      echo "${wk} ya está en el cluster"
      continue
    else
      echo "Uniendo ${wk} al cluster"
      talosctl apply-config --insecure --nodes "$wk" --file worker.yaml
    fi

    sleep 2

  done
}

if [[ ${1:-} == "--init" ]]; then
  init_cluster
  reconcile_cluster
else
  reconcile_cluster
fi
