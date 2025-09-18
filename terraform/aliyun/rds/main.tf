# 配置阿里云提供商
terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
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

# 使用现有的VPC和VSwitch
data "alicloud_vpcs" "existing" {
  ids = ["vpc-bp1vtn5sob59pxuxy8tg3"]
}

data "alicloud_vswitches" "existing" {
  ids = ["vsw-bp1jnpj5imdvo790bz0nf"]
}

# 创建RDS MySQL实例
resource "alicloud_db_instance" "goldtime-rds-instance-a" {
  instance_name        = "goldtime-rds-instance-a"
  engine               = "MySQL"
  engine_version       = "8.0"
  instance_type        = "mysql.n2.medium.1"  # 根据需求调整实例规格
  instance_storage     = 20
  instance_charge_type = "Postpaid"  # 按量付费，可选Prepaid（包年包月）
  vswitch_id           = "vsw-bp1jnpj5imdvo790bz0nf"
  security_ips         = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  zone_id              = "cn-hangzhou-k"  # 明确指定可用区

  # 指定资源组
  resource_group_id = "rg-aek3b5tr2l3v4ci"

  # 重要：配置超时时间
  timeouts {
    create = "60m"  # RDS创建通常需要较长时间
    update = "30m"
  }

  # 明确依赖关系
  depends_on = [
    data.alicloud_vpcs.existing,
    data.alicloud_vswitches.existing
  ]

  # 数据库参数配置
  parameters {
    name  = "connect_timeout"
    value = "60"
  }
  
  parameters {
    name  = "interactive_timeout"
    value = "28800"
  }
  
  parameters {
    name  = "wait_timeout"
    value = "28800"
  }
}

# 创建数据库账号
resource "alicloud_db_account" "goldtime-rds-instance-a-account" {
  db_instance_id      = alicloud_db_instance.goldtime-rds-instance-a.id
  account_name        = "goldtime_rds_instance_a_account"
  account_password    = "12345678XT!DB"  # 请修改为强密码
  account_type        = "Normal"
  
  # 等待实例完全创建完成
  depends_on = [alicloud_db_instance.goldtime-rds-instance-a]
}

# 创建数据库
resource "alicloud_db_database" "go_gin_api" {
  instance_id   = alicloud_db_instance.goldtime-rds-instance-a.id
  name          = "go_gin_api"
  character_set = "utf8mb4"
  description   = "GoldTime database"
  
  # 等待实例和账号创建完成
  depends_on = [
    alicloud_db_instance.goldtime-rds-instance-a,
    alicloud_db_account.goldtime-rds-instance-a-account
  ]
}

# 输出连接信息
output "rds_connection" {
  value = {
    endpoint = alicloud_db_instance.goldtime-rds-instance-a.connection_string
    username = alicloud_db_account.goldtime-rds-instance-a-account.account_name
    database = alicloud_db_database.go_gin_api.name
  }
  sensitive = true
}

# 输出网络信息用于验证
output "network_info" {
  value = {
    vpc_id     = "vpc-bp1vtn5sob59pxuxy8tg3"
    vswitch_id = "vsw-bp1jnpj5imdvo790bz0nf"
    zone_id    = "cn-hangzhou-k"
  }
}

# 输出实例信息
output "rds_instance_info" {
  value = {
    instance_id   = alicloud_db_instance.goldtime-rds-instance-a.id
    instance_name = alicloud_db_instance.goldtime-rds-instance-a.instance_name
    engine        = alicloud_db_instance.goldtime-rds-instance-a.engine
    engine_version = alicloud_db_instance.goldtime-rds-instance-a.engine_version
    status        = alicloud_db_instance.goldtime-rds-instance-a.status
  }
}

# 输出实例状态用于调试
output "rds_status" {
  value = alicloud_db_instance.goldtime-rds-instance-a.status
}