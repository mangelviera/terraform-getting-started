data "aws_caller_identity" "current" {}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.1"

  identifier = var.name

  engine               = "postgres"
  engine_version       = "12.10"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.t2.micro"

  allocated_storage     = 10
  max_allocated_storage = 20

  db_name  = var.db_name
  username = var.username
  port     = 5432
  storage_encrypted = false

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.sg_ec2.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  tags = var.default_tags
}