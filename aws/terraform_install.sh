#!/bin/bash

# This script updates the package list, installs Gnupg, downloads the Hashicorp signing key, adds the Hashicorp repository and installs Terraform.

# Update Apt. 
# This command $(date +%s) prints the current date/time as Unix timestamp. This command $(stat -c %Y /var/lib/apt/periodic/update-success-stamp) prints the last modification of the file /var/lib/apt/periodic/update-success-stamp as Unix timestamp. If current time - last update time is greater than 24 hours then package lists will be updated. This conditional will also print the last time apt was updated.
if (( $(date +%s) - $(stat -c %Y /var/lib/apt/periodic/update-success-stamp) > 24*60*60 ))
then
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
else
  echo -e "\n\033[1;32m==== Apt is up to date... Last update: $(date -d @$(stat -c %Y /var/lib/apt/periodic/update-success-stamp)) ====\033[0m\n"
fi

# Install Gnupg
if ( which gnupg > /dev/null )
then
  echo -e "\n\033[1;32m==== Gnupg present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Gnupg ====\033[0m\n"
  install -y gnupg software-properties-common
fi

# Install GPG key
if [ -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]
then
  echo -e "\n\033[1;32m==== Hashi key present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Downloading Hashi key  ====\033[0m\n"
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
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