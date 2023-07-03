#!/bin/bash

# This script connects to a Raspberry Pi 400 running Ubuntu Server, synchronizes the local directory with the Pi, executes commands on the Pi, and logs in.
echo -e "\n\033[1;32m==== Validate Pi server is running ====\033[0m\n"
while true
do
  if (  ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -T "$USER@$PI_HOST" 'exit' &> /dev/null )
  then
    echo -e "\n\033[1;32m==== Server is running ====\033[0m\n"
    break
  else
    printf "\033[31m.\033[0m"
    sleep 2
  fi
done

# Install Homebrew
if ( which brew > /dev/null ) 
then
  echo -e "\n\033[1;32m==== Brew installed ====\033[0m\n"
else 
  echo -e "\n\033[1;33m==== Installing Brew ====\033[0m\n"
  sudo true; NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Rsync
if ( which rsync > /dev/null )
then
  echo -e "\n\033[1;32m==== Rsync present ====\033[0m\n"
else
  echo -e "\n\033[1;33m==== Installing Rsync ====\033[0m\n"
  brew install rsync
fi

echo -e "\n\033[1;32m==== Copying files to Pi ====\033[0m\n"
rsync -av -e "ssh -o StrictHostKeyChecking=no" --delete --exclude={'.git','.gitignore','commands.txt','README.md','pi_local.sh',} $(pwd) $USER@$PI_HOST:/home/$USER

echo -e "\n\033[1;32m==== Executing commands on Pi Server ====\033[0m\n"
ssh -t -o StrictHostKeyChecking=no $USER@$PI_HOST 'cd multicloud_terraform/aws && bash install_terraform.sh && bash aws_install.sh'

echo -e "\n\033[1;32m==== SSH into Pi ====\033[0m\n"
ssh -t -o StrictHostKeyChecking=no $USER@$PI_HOST 