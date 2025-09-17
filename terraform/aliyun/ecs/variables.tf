# variables.tf

variable "region" {
  description = "The region to create resources in"
  type        = string
  default     = "cn-hangzhou"
}

variable "zone_available_disk_category" {
  description = "Available disk category for filtering zones"
  type        = string
  default     = "cloud_essd"
}

variable "image_name_regex" {
  description = "Regex pattern to match the desired image"
  type        = string
  default     = "^ubuntu_22_04_x64"
}

variable "instance_type_family" {
  description = "ECS instance type family"
  type        = string
  default     = "ecs.sn1ne"
}

variable "cpu_core_count" {
  description = "cpu_core_count(Core)"
  type        = number
  default     = 1
}

variable "memory_size" {
  description = "memory_size(GB)"
  type        = number
  default     = 2
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "goldtime_vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/12"
}

variable "vswitch_name" {
  description = "Name of the VSwitch"
  type        = string
  default     = "goldtime_vswitch"
}

variable "vswitch_cidr_block" {
  description = "CIDR block for the VSwitch"
  type        = string
  default     = "172.16.0.0/21"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "goldtime_sg"
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for Terraform test"
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.s6-c1m1.small"
}

variable "instance_name" {
  description = "Name of the ECS instance"
  type        = string
  default     = "goldtime_server"
}

variable "system_disk_category" {
  description = "Category of the system disk"
  type        = string
  default     = "cloud_essd"
}

variable "system_disk_size" {
  description = "Size of the system disk in GB"
  type        = number
  default     = 40
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outbound internet bandwidth in Mbps"
  type        = number
  default     = 5
}

variable "instance_password" {
  description = "Password for the ECS instance"
  type        = string
  sensitive   = true # 标记为敏感变量，输出时会隐藏
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    CreatedBy = "GoldTime"
    Env       = "Dev"
  }
}