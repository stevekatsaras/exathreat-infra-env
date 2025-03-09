variable "cidr" {
  type = map(string)
  default = {
    vpc           = "10.70.0.0/16"
    public-a      = "10.70.0.0/24"
    public-b      = "10.70.1.0/24"
    public-c      = "10.70.2.0/24"
    private-db-a  = "10.70.16.0/20"
    private-db-b  = "10.70.32.0/20"
    private-db-c  = "10.70.48.0/20"
    private-web-a = "10.70.64.0/18"
    private-web-b = "10.70.128.0/18"
    private-web-c = "10.70.192.0/18"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["a", "b"]
}

variable "Owner" {
  default = "Karim Khairat: karim@datadentity.com"
}

variable "Product" {
  default = "exathreat"
}

variable "env" {
  default = "beta"
}

variable "RegCode" {
  default = "nva"
}

variable "domain" {
  default = "exathreat.com"
}

variable "ecs_ami" {
  default = "ami-0ff8a91507f77f867"
}

variable "bastion_ami" {
  default = "ami-07ebfd5b3428b6f4d"
}

variable "log_retention" {
  default = 1
}

variable "db_max_storage" {
  default = 500
}

variable "db_alloc_storage" {
  default = 50
}

variable "db_instance_class" {
  default = "db.m5.large"
}

variable "api_cpu" {
  default = 512
}

variable "api_memory" {
  default = 1024
}

variable "portal_cpu" {
  default = 512
}

variable "portal_memory" {
  default = 1024
}

variable "scheduler_cpu" {
  default = 512
}

variable "scheduler_memory" {
  default = 1024
}

variable "portal_asg_max" {
  default = 2
}

variable "portal_asg_min" {
  default = 1
}

variable "api_asg_max" {
  default = 4
}

variable "api_asg_min" {
  default = 1
}

variable "es_master_type" {
  default = "t3.medium.elasticsearch"
}

variable "es_master_count" {
  default = 3
}

variable "es_instance_type" {
  default = "m5.large.elasticsearch"
}

variable "es_instance_count" {
  default = 2
}

variable "es_volume_type" {
  default = "gp2"
}

variable "es_volume_size" {
  default = 512
}

locals {
  NameTag = format("%s-%s-%s", var.env, var.RegCode, var.Product)
  DbName  = format("%s%s%sMysql", var.env, var.RegCode, var.Product)
}