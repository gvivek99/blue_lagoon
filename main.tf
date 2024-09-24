data "aws_vpc" "default"{
	default = "true"
}

resource "aws_instance" "blog"{
	ami = "ami-08d8ac128e0a1b91c"
	instance_type = var.instance_type
	
	tags = {
		Name = "Learning Terraform"
	}
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "blog" {
  name        = "blogsg"
  description = "Blog security group"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in"{
	type = "ingress"
    	from_port   = 80
    	to_port     = 80
    	protocol    = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]
	
	security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_http_secure_in"{
	type = "ingress"
    	from_port = 443
    	to_port = 443
    	protocol = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]
	
	security_group_id = aws_security_group.blog.id
}

resource "aws_security_group_rule" "blog_http_out"{
	type = "egress"
    	from_port = 0
    	to_port = 0
    	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	
	security_group_id = aws_security_group.blog.id
}
