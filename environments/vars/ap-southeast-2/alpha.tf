variable "cidr" {
  type = map(string)
  default = {
    vpc           = "10.60.0.0/16"
    public-a      = "10.60.0.0/24"
    public-b      = "10.60.1.0/24"
    public-c      = "10.60.2.0/24"
    private-db-a  = "10.60.16.0/20"
    private-db-b  = "10.60.32.0/20"
    private-db-c  = "10.60.48.0/20"
    private-web-a = "10.60.64.0/18"
    private-web-b = "10.60.128.0/18"
    private-web-c = "10.60.192.0/18"
  }
}

variable "region" {
  default = "ap-southeast-2"
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
  default = "alpha"
}

variable "RegCode" {
  default = "syd"
}

variable "domain" {
  default = "exathreat.com"
}

variable "ecs_ami" {
  default = "ami-09b42976632b27e9b"
}

variable "bastion_ami" {
  default = "ami-02a599eb01e3b3c5b"
}

variable "log_retention" {
  default = 1
}

variable "db_max_storage" {
  default = 250
}

variable "db_alloc_storage" {
  default = 25
}

variable "db_instance_class" {
  default = "db.t3.medium"
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
  default = "t3.medium.elasticsearch"
}

variable "es_instance_count" {
  default = 2
}

variable "es_volume_type" {
  default = "gp2"
}

variable "es_volume_size" {
  default = 200
}

locals {
  NameTag = format("%s-%s-%s", var.env, var.RegCode, var.Product)
  DbName  = format("%s%s%sMysql", var.env, var.RegCode, var.Product)
}