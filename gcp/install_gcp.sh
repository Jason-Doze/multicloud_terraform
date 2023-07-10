#!/bin/bash

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

# Install apt-transport-https
if ( dpkg -s apt-transport-https > /dev/null )
then
  echo -e "\n\033[1;32m==== Apt-transport-https present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Apt-transport-https ====\033[0m\n"
  sudo apt install -y apt-transport-https
fi

# Install ca-certificates
if ( dpkg -s ca-certificates > /dev/null )
then
  echo -e "\n\033[1;32m==== Ca-certificates present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing ca-certificates ====\033[0m\n"
  sudo apt install -y ca-certificates
fi

# Add Gcloud CLI distribution
if [ -f /etc/apt/sources.list.d/google-cloud-sdk.list ]
then
  echo -e "\n\033[1;32m==== Gcloud distro added ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Adding Gcloud distro  ====\033[0m\n"
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
fi

# Add key fingerprint
if [ -f /usr/share/keyrings/cloud.google.gpg ]
then
  echo -e "\n\033[1;32m==== Google key verified ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Verifying Google key  ====\033[0m\n"
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
fi

# Update Apt
if ( apt-cache show google-cloud-cli &> /dev/null )
then
  echo -e "\n\033[1;32m==== Google CLI in cache ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Updating Apt ====\033[0m\n"
  sudo apt update 
fi

# Install Google CLI
if ( which google-cloud-cli > /dev/null )
then
  echo -e "\n\033[1;32m==== Google CLI present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Google CLI ====\033[0m\n"
  sudo apt install google-cloud-cli
fi



