#!/bin/bash

# This script installs the Azure CLI.

# Update Apt
if (( $(date +%s) - $(stat -c %Y /var/lib/apt/periodic/update-success-stamp) > 24*60*60 ))
then
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
else
  echo -e "\n\033[1;32m==== Apt updated ====\033[0m\n"
fi

# Install Homebrew
if ( which brew > /dev/null ) 
then
  echo -e "\n\033[1;32m==== Brew installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing brew ====\033[0m\n"
  sudo true; NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Azure-CLI
if ( which az > /dev/null ) 
then
  echo -e "\n\033[1;32m==== Azure-CLI installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing Azure-CLI ====\033[0m\n"
  brew update && brew install azure-cli
fi
