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

# 查询现有资源组信息
data "alicloud_resource_manager_resource_groups" "groups" {
  name_regex = "GoldTime"  # 根据资源组名称过滤
}

# 使用现有的 VPC 和 vSwitch
data "alicloud_vpcs" "existing" {
  ids = ["vpc-bp1vtn5sob59pxuxy8tg3"]
}

data "alicloud_vswitches" "existing" {
  ids = ["vsw-bp1jnpj5imdvo790bz0nf"]
}

# 创建 Redis 实例
resource "alicloud_kvstore_instance" "goldtime-kv-instance-a" {
  instance_class    = "redis.master.small.default"  # 实例规格
  db_instance_name  = "goldtime-kv-instance-a"        # 实例名称
  vswitch_id        = "vsw-bp1jnpj5imdvo790bz0nf"   # 直接使用现有的 vSwitch ID
  security_ips      = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  engine_version    = "5.0"                         # Redis版本
  instance_type     = "Redis"                       # 实例类型
  zone_id           = "cn-hangzhou-k"               # 可用区
  
  # 指定资源组 - 方式一：直接使用已知的资源组ID
  resource_group_id = "rg-aek3b5tr2l3v4ci"  # 替换为 GoldTime 资源组的实际ID
  
  # 或者方式二：使用数据源查询到的资源组ID（取消注释下面这行，注释掉上面那行）
  # resource_group_id = data.alicloud_resource_manager_resource_groups.groups.groups[0].id
  
  # Redis 配置参数
  config = {
    appendonly               = "yes"
    "lazyfree-lazy-eviction" = "yes"
    maxmemory-policy         = "volatile-lru"
  }
  
  # 标签
  tags = {
    Created     = "Terraform"
    Environment = "Production"
    VPC         = "vpc-bp1vtn5sob59pxuxy8tg3"
  }
  
  # 备份设置
  backup_period = ["Monday", "Wednesday", "Friday"]
  backup_time   = "02:00Z-03:00Z"
  
  # 如果需要设置密码，取消注释下面的配置
  password = "12345678XT!"
}

# 输出实例信息
output "redis_instance_id" {
  value = alicloud_kvstore_instance.goldtime-kv-instance-a.id
}

output "redis_connection_domain" {
  value = alicloud_kvstore_instance.goldtime-kv-instance-a.connection_domain
}

output "redis_port" {
  value = alicloud_kvstore_instance.goldtime-kv-instance-a.port
}

output "redis_status" {
  value = alicloud_kvstore_instance.goldtime-kv-instance-a.status
}

# 输出资源组信息（用于验证）
output "resource_group_info" {
  value = data.alicloud_resource_manager_resource_groups.groups.groups
}