output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instance_id" {
  value = module.public_instance.instance_id
}

output "private_instance_id" {
  value = module.private_instance.instance_id
}
