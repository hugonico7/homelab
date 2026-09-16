## Cililum
resource "helm_release" "cilium" {
  name       = "cilium"
  chart      = "cilium"
  repository = "https://helm.cilium.io/"
  namespace  = "kube-system"
  version    = "1.18.0"

  set = local.cilium_config
}

## ArgoCD
resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argocd"
  create_namespace = true

  version = "10.9.1"

  set = local.argocd_config
}
