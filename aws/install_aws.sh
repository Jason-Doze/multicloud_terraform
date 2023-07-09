#!/bin/bash

# This script installs the AWS CLI.

# Install unzip
if ( which unzip > /dev/null )
then
  echo -e "\n\033[1;32m==== Unzip installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing unzip ====\033[0m\n"
  sudo apt install unzip
fi

# Install AWS CLI 
if [ -f awscliv2.zip ]
then
  echo -e "\n\033[1;32m==== awscliv2.zip present ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Downloading awscliv2.zip ====\033[0m\n"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
fi

if ( aws --version )
then
  echo -e "\n\033[1;32m==== AWS-CLI installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing AWS_CLI ====\033[0m\n"
  unzip -o awscliv2.zip
  sudo ./aws/install
fi

