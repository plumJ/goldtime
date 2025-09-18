terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.209.0"
    }
  }
}

provider "alicloud" {
  region = "cn-hangzhou"
}

# 查询现有VPC和vSwitch数据
data "alicloud_vpcs" "existing" {
  ids = ["vpc-bp1vtn5sob59pxuxy8tg3"]
}

data "alicloud_vswitches" "existing" {
  ids = ["vsw-bp1jnpj5imdvo790bz0nf"]
}

resource "alicloud_kvstore_instance" "goldtime-kv-instance-a" {
  instance_class    = "redis.master.small.default"
  db_instance_name  = "goldtime-kv-instance-a"
  vswitch_id        = "vsw-bp1jnpj5imdvo790bz0nf"
  security_ips      = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  engine_version    = "5.0"
  instance_type     = "Redis"
  zone_id           = "cn-hangzhou-k"
  resource_group_id = "rg-aek3b5tr2l3v4ci"
  
  config = {
    appendonly               = "yes"
    "lazyfree-lazy-eviction" = "yes"
    maxmemory-policy         = "volatile-lru"
  }
  
  tags = {
    Created     = "Terraform"
    Environment = "Production"
    VPC         = "vpc-bp1vtn5sob59pxuxy8tg3"
  }
  
  backup_period = ["Monday", "Wednesday", "Friday"]
  backup_time   = "02:00Z-03:00Z"
  password      = "12345678XT!"
  
  # 关键：配置超时时间
  timeouts {
    create = "60m"
    update = "30m"
  }
  
  depends_on = [
    data.alicloud_vpcs.existing,
    data.alicloud_vswitches.existing
  ]
}

# 输出实例基本信息
output "redis_instance_id" {
  description = "Redis实例ID"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.id
}

output "redis_instance_name" {
  description = "Redis实例名称"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.db_instance_name
}

# 输出连接信息
output "redis_connection_domain" {
  description = "Redis连接域名"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.connection_domain
}

output "redis_connection_string" {
  description = "Redis连接字符串"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.connection_string
}

output "redis_port" {
  description = "Redis端口号"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.port
}

# 输出状态信息
output "redis_status" {
  description = "Redis实例状态"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.status
}

output "redis_engine_version" {
  description = "Redis引擎版本"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.engine_version
}

# 输出配置信息
output "redis_config" {
  description = "Redis配置参数"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.config
}

# 输出资源组信息
output "redis_resource_group_id" {
  description = "Redis资源组ID"
  value       = alicloud_kvstore_instance.goldtime-kv-instance-a.resource_group_id
}

# 输出备份信息
output "redis_backup_info" {
  description = "Redis备份配置"
  value = {
    backup_period = alicloud_kvstore_instance.goldtime-kv-instance-a.backup_period
    backup_time   = alicloud_kvstore_instance.goldtime-kv-instance-a.backup_time
  }
}

# 输出实例规格信息
output "redis_instance_spec" {
  description = "Redis实例规格"
  value = {
    instance_class = alicloud_kvstore_instance.goldtime-kv-instance-a.instance_class
    instance_type  = alicloud_kvstore_instance.goldtime-kv-instance-a.instance_type
    capacity       = alicloud_kvstore_instance.goldtime-kv-instance-a.capacity
  }
}