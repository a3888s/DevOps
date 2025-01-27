module "eks-external-dns" {
  source                           = "lablabs/eks-external-dns/aws"    # Джерело модуля для External DNS
  version                          = "1.2.0"                          # Версія модуля

  # OIDC видавець, необхідний для налаштування IAM ролей для External DNS
  cluster_identity_oidc_issuer     = aws_eks_cluster.danit.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn   # ARN провайдера OIDC
}
