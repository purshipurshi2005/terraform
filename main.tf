provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
vpc_security_group_ids = [aws_security_group.instance.id]

user_data =<<-EOF
	  #!/bin/bash
	  echo "Hello World" >index.html
	  nohup busybox httpd -f -p 8080 &
	  EOF
user_data_replace_on_change = true
 tags = {
    Name = "terraform-example"
  }
  instance_type = "t2.micro"
}
