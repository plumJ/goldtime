# main.tf

terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.209.0"
    }
  }
}

provider "alicloud" {
  region = "cn-zhangjiakou"
}

resource "alicloud_instance" "i-8vb2h5z76r6ypx90jpl6" {
    availability_zone                   = "cn-zhangjiakou-a"
    instance_charge_type                = "PrePaid"
    instance_name                       = "iZ8vb2h5z76r6ypx90jpl6Z"
    instance_type                       = "ecs.s6-c1m1.small"
    image_id                            = "aliyun_3_x64_20G_alibase_20230110.vhd"
    vswitch_id                          = "vsw-8vb8eup20x1n1lv2j6rls"
    security_groups                     = [
        "sg-8vbi4cl2cvhcrzkhl9z2",
    ]
    system_disk_category                = "cloud_essd"
    internet_max_bandwidth_out          = 0
    renewal_status                     = "AutoRenewal"
    auto_renew_period                  = 12
    timeouts {}
    dry_run = false
    force_delete = false
    include_data_disks = false
}