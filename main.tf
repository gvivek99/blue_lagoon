data "aws_ami" "app_ami"{
	most_recent = "true"
  
	filter { 
		name = "name"
		values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
	}
  
	filter {
		name = "virtualization-type"
		value = ["hvm"]
	}
  
	owners = [""] #Bitnami
}

data "aws_vpc" "default"{
	default = "true"
}

resource "aws_instacnce" "blog"{
	ami = "data.aws_ami.app_ami.id"
	instance_type = var.instance_type
	
	tags{
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

resource "aws_security_group_rule" "blog_http_out"{
	type = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
	
	security_group_id = aws_security_group.blog.id
}