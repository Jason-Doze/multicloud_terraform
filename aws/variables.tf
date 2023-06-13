variable "access_key" {
        description = "Access key to AWS console"
}

variable "secret_key" {
        description = "Secret key to AWS console"
}

variable "instance_name" {
        description = "Name of the instance to be created"
        default = "aws_terra"
}

variable "instance_type" {
        default = "t2.micro"
}

variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-0e2f7a0426d22b45d"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-09d56f8956ab235b3"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair" {
        default = "aws_rsa_key"
}