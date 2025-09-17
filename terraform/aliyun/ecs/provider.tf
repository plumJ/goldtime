# provider.tf

terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.209.0" # 建议使用最新稳定版本
    }
  }
}