#!/bin/bash

# This script installs the Azure CLI.

# Update Apt
if ( apt-cache show az &> /dev/null )
then
  echo -e "\n\033[1;32m==== Gnupg in cache ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
fi

# Install Azure-CLI
if ( which az > /dev/null ) 
then
  echo -e "\n\033[1;32m==== Azure-CLI installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing Azure-CLI ====\033[0m\n"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi


# az login

# create resource group
# create vm https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli