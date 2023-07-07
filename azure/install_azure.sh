#!/bin/bash

# This script installs the Azure CLI.

# Export environment variables
source .env

# Install curl
if ( which curl > /dev/null )
then
  echo -e "\n\033[1;32m==== Curl installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing curl ====\033[0m\n"
  sudo apt install -y curl
fi

# Install gnupg
if ( which gnupg > /dev/null )
then
  echo -e "\n\033[1;32m==== Gnupg installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing gnupg ====\033[0m\n"
  sudo apt install -y gnupg
fi

# Install ca-certificates
if ( dpkg -s ca-certificates &> /dev/null )
then
  echo -e "\n\033[1;32m==== Ca-certificates installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing ca-certificates ====\033[0m\n"
  sudo apt install -y ca-certificates
fi

# Install apt-transport-https
if ( dpkg -s apt-transport-https &> /dev/null )
then
  echo -e "\n\033[1;32m==== Apt-transport-https installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing apt-transport-https ====\033[0m\n"
  sudo apt install -y apt-transport-https
fi

# Install lsb-release
if ( pkg -s lsb-release &> /dev/null )
then
  echo -e "\n\033[1;32m==== Lsb-release installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing lsb-release ====\033[0m\n"
  sudo apt install -y lsb-release
fi

# Add Microsoft signing key
if [ -f /etc/apt/keyrings/microsoft.gpg ]
then
  echo -e "\n\033[1;32m==== Microsoft signing key present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Adding Microsoft signing key ====\033[0m\n"
  sudo mkdir -p /etc/apt/keyrings
  curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
fi

# Install Azure CLI repo
if [ -f /etc/apt/sources.list.d/azure-cli.list ]
then
  echo -e "\n\033[1;32m==== Azure CLI repository present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Install Azure CLI repository ====\033[0m\n"
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] \
  https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/azure-cli.list > /dev/null
fi

# Update Apt
if ( apt-cache show az &> /dev/null )
then
  echo -e "\n\033[1;32m==== Azure-CLI in cache ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
fi

# Install Azure CLI 
if ( which az > /dev/null )
then
  echo -e "\n\033[1;32m==== Azure-CLI installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Azure-CLI ====\033[0m\n"
  sudo apt install azure-cli 
fi

# Create an RSA SSH key pair
if [ -f ./id_rsa ]
then  
  echo -e "\n\033[1;32m==== SSH key present  ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Creating SSH key pair ====\033[0m\n"
  ssh-keygen -t rsa -N '' -f ./id_rsa
fi

# Login to Azure
az login --tenant $ARM_TENANT_ID
