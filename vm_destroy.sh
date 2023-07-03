#!/bin/bash

# This script terminates the VM, removes the VM's fingerprint from known hosts, deletes SSH keys, and removes the cloud-init.yaml file associated with the VM.

#Delete fingerprint from known_hosts
if ( ssh-keygen -H -F "$(multipass info nameless |  grep IPv4  | awk '{print $2}')" ) 
then
  echo -e "\n\033[1;33m==== Deleting fingerprint from known host ====\033[0m\n"
  ssh-keygen -f ~/.ssh/known_hosts -R "$(multipass info nameless |  grep IPv4  | awk '{print $2}')"
else 
  echo -e "\n\033[1;32m==== Fingerprint not present in known host ====\033[0m\n"
fi 

# Delete SSH keys
if [ -f id_ed25519 ]
then
  echo -e "\n\033[1;33m==== Deleting SSH Keys ====\033[0m\n"
  rm id_ed25519 id_ed25519.pub
else
  echo -e "\n\033[1;32m==== SSH keys not present ====\033[0m\n" 
fi

# Delete the cloud-init.yaml file
if [ -f cloud-init.yaml ]
then 
  echo -e "\n\033[1;33m==== Deleting cloud-init.yaml file ====\033[0m\n"
  rm cloud-init.yaml
else
  echo -e "\n\033[1;32m==== Cloud-init.yaml not present ====\033[0m\n" 
fi

# Delete the VM
if ( multipass info nameless > /dev/null ) 
then
  echo -e "\n\033[1;33m==== Deleting VM ====\033[0m\n"
  multipass delete --purge nameless 
else 
  echo -e "\n\033[1;32m==== VM not present ====\033[0m\n"
fi 



