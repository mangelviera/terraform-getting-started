resource "aws_ecr_repository" "ecr" {
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"
}