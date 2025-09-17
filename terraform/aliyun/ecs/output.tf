output "ecs_public_ip" {
  value = alicloud_instance.instance.public_ip
}

output "ecs_instance_id" {
  value = alicloud_instance.instance.id
}

output "ecs_instance_name" {
  value = alicloud_instance.instance.instance_name
}