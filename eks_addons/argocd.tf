
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true
  wait             = true
  timeout          = 900

  values = [
    yamlencode({
      server = {
        insecure = true

        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}
