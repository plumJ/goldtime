# main.tf

# 配置 Provider
provider "alicloud" {
  region = var.region
}

# 获取可用区
data "alicloud_zones" "default" {
  available_disk_category     = var.zone_available_disk_category
  available_resource_creation = "VSwitch"
}

# 获取镜像 ID
data "alicloud_images" "default" {
  name_regex  = var.image_name_regex
  most_recent = true
  owners      = "system"
}

# 获取实例规格
data "alicloud_instance_types" "default" {
  instance_type_family = var.instance_type_family
  cpu_core_count       = var.cpu_core_count
  memory_size          = var.memory_size
}

# 创建专有网络 VPC
resource "alicloud_vpc" "default" {
  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr_block
}

# 创建虚拟交换机 VSwitch
resource "alicloud_vswitch" "default" {
  vpc_id       = alicloud_vpc.default.id
  cidr_block   = var.vswitch_cidr_block
  zone_id      = data.alicloud_zones.default.zones[0].id
  vswitch_name = var.vswitch_name
}

# 创建安全组
resource "alicloud_security_group" "default" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = alicloud_vpc.default.id
}

# 添加安全组规则（允许 SSH 和 HTTP）
resource "alicloud_security_group_rule" "ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

# 创建 ECS 实例
resource "alicloud_instance" "instance" {
  availability_zone           = data.alicloud_zones.default.zones[0].id
  instance_type               = data.alicloud_instance_types.default.ids[0]
  instance_name               = var.instance_name
  vswitch_id                  = alicloud_vswitch.default.id
  security_groups             = [alicloud_security_group.default.id]
  image_id                    = data.alicloud_images.default.images[0].id
  system_disk_category        = var.system_disk_category
  system_disk_size            = var.system_disk_size
  internet_max_bandwidth_out  = var.internet_max_bandwidth_out
  password                    = var.instance_password

  tags = var.tags
}