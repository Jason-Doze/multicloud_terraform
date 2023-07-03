#!/bin/bash

# Deploy AWS instance using terraform

# Export environment variables
source .env

# Initialize Terraform
terraform init

# Create a Terraform execution plan
terraform plan 

# Format the configuration
terraform fmt

# Validate the configuration
terraform validate

# Create infrastructure
terraform apply 

# Inspect state
terraform show

# Destroy Infrastructure
# terraform destroy