locals {
  project_name = "HW19"
  environment  = "dev"

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
  }
}
