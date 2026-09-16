data "http" "yaml_manifest" {
  for_each = toset(local.gateway_api_crds)
  url      = each.value
}
resource "kubectl_manifest" "gateway_api_crds" {
  for_each          = data.http.yaml_manifest
  yaml_body         = each.value.response_body
  server_side_apply = true
}
