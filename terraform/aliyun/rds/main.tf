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
  
  parameters {
    name  = "connect_timeout"
    value = "60"
  }
}

# 创建数据库账号
resource "alicloud_db_account" "mysql_db_account" {
  db_instance_id      = alicloud_db_instance.goldtime-rds-instance-a.id
  account_name        = "mysql_db_account"
  account_password    = "12345678XT!DB"  # 请修改为强密码
  account_type        = "Normal"
}

# 创建数据库
resource "alicloud_db_database" "goldtime-rds-instance-a-db1" {
  instance_id   = alicloud_db_instance.goldtime-rds-instance-a.id
  name          = "goldtime-rds-instance-a-db1"
  character_set = "utf8mb4"
  description   = "GoldTime database"
}

# 输出连接信息
output "rds_connection" {
  value = {
    endpoint = alicloud_db_instance.goldtime-rds-instance-a.connection_string
    username = alicloud_db_account.mysql_db_account.name
    database = alicloud_db_database.goldtime-rds-instance-a-db1.name
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
  }
}