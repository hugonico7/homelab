module "kubernetes-infra" {

  source = "./modules/kubernetes"

  control-plane-config = local.control-plane-config

  worker-config = local.worker-config

}
