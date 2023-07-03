terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "aws_terra_01" {
  ami           = "ami-06a1f46caddb5669e"
  instance_type = "t2.micro"

  tags = {
    Name = "aws_terra_01"
  }
}
