# OIDC Provider: An OIDC provider is a service that allows you to authenticate users and applications using the OpenID Connect (OIDC) protocol. In this case, we are creating an OIDC provider for our EKS cluster, which will allow us to use IAM roles for service accounts (IRSA) to grant permissions to our Kubernetes workloads.
data "tls_certificate" "eks" {
  url = module.eks.oidc_issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.oidc_issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]
}