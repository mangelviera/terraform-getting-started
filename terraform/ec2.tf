locals {
  user_data = <<-EOT
  #!/bin/bash
  yum update -y
  yum install docker -y
  service docker start
  usermod -a -G docker ec2-user
  chkconfig docker on
  EOT
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.1"

  name = var.name

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.sg_ec2.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false

  iam_instance_profile = aws_iam_role.ec2_role.name

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  enable_volume_tags = false

  tags = var.default_tags
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2ConnectRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_connect_policy" {
  name = "EC2ConnectPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "ec2-instance-connect:SendSSHPublicKey",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_connect_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_connect_policy.arn
  role       = aws_iam_role.ec2_role.name
}
