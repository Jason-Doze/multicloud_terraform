#!/bin/bash

# This script updates the package list, installs Gnupg, downloads the Hashicorp signing key, adds the Hashicorp repository and installs Terraform.

# Update Apt
if ( apt-cache show gnupg &> /dev/null )
then
  echo -e "\n\033[1;32m==== Gnupg in cache ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
fi

# Install Gnupg
if ( which gnupg > /dev/null )
then
  echo -e "\n\033[1;32m==== Gnupg present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Gnupg ====\033[0m\n"
  sudo apt install -y gnupg
fi

# Install software-properties-common
if ( dpkg -s software-properties-common > /dev/null )
then
  echo -e "\n\033[1;32m==== Software-properties-common present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing software-properties-common ====\033[0m\n"
  sudo apt install -y software-properties-common
fi

# Install GPG key
if [ -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
then
  echo -e "\n\033[1;32m==== Hashi key present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Downloading Hashi key  ====\033[0m\n"
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | /
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
fi

# Verify key fingerprint
if [ -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
then
  echo -e "\n\033[1;32m==== Hashi key verified ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Verifying Hashi key  ====\033[0m\n"
  gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
fi

# Add Hashi repo
if [ -f /etc/apt/sources.list.d/hashicorp.list ]
then
  echo -e "\n\033[1;32m==== Hashi repo present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Adding Hashi repo ====\033[0m\n"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

# Update Apt
if ( apt-cache show terraform &> /dev/null )
then
  echo -e "\n\033[1;32m==== Terraform in cache ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Updating Terraform ====\033[0m\n"
  sudo apt update 
fi

# Install Terraform
if ( which terraform > /dev/null )
then
  echo -e "\n\033[1;32m==== Terraform installed ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Terraform ====\033[0m\n"
  sudo apt install terraform
fi