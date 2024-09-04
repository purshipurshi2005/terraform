provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound rule (allows all traffic by default, can be restricted)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-app-repo"
  image_tag_mutability = "MUTABLE"  # Options: MUTABLE or IMMUTABLE
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "MyAppRepo"
    Environment = "Production"
  }
}
output "ecr_repository_url" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}
