resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = format("%s-es", local.NameTag)
  elasticsearch_version = "7.10"
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = true
    "override_main_response_version" = false
  }
  cluster_config {
    dedicated_master_enabled = true
    dedicated_master_type    = var.es_master_type
    dedicated_master_count   = var.es_master_count
    instance_type            = var.es_instance_type
    instance_count           = var.es_instance_count
    zone_awareness_enabled   = true
  }
  ebs_options {
    ebs_enabled = true
    volume_type = var.es_volume_type
    volume_size = var.es_volume_size
  }
  node_to_node_encryption {
    enabled = true
  }
  vpc_options {
    subnet_ids         = [data.aws_subnet.private_dba.id, data.aws_subnet.private_dbb.id]
    security_group_ids = [data.aws_security_group.elasticsearch.id]
  }
  access_policies = <<CONFIG
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "es:*",
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.NameTag}-es/*"
      }
    ]
  }
  CONFIG
}
