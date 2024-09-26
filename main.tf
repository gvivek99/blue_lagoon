data "aws_vpc" "default"{
	default = "true"
}

module "blog_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1b", "us-west-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "blog"{
	ami = "ami-08d8ac128e0a1b91c"
	instance_type = var.instance_type
	
	subnet_id = module.blog_vpc.public_subnets[0]

	tags = {
		Name = "Learning Terraform"
	}
}

module "blog_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "blog"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.blog_vpc.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["http-80-tcp","https-443-tcp"]
  egress_rules            = ["all-all"]
  egress_cidr_blocks      = ["0.0.0.0/0"]
  
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "blog" {
  name        = "blogsg"
  description = "Blog security group"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_iam_user" "myuser"{
    name = "iamuser".${count.index}
    count = 3
    path = "/system/"
    tags = {
        tag-key = ""iamuser".${count.index}
    }

}

