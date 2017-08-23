#!/bin/bash

while getopts ":s:r:v:k:u:p:" opt; do
  case $opt in
    s) subscription_id="$OPTARG"
    ;;
    r) resource_group="$OPTARG"
    ;;
    v) vault_name="$OPTARG"
    ;;
    k) key_name="$OPTARG"
    ;;
    u) key_value="$OPTARG"
    ;;
    p) port="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z $port ]; then
    port=50342
fi


if [ -z $key_value ]; then
    # generate ssh key
    sudo rm -f ~/.ssh/id_rsa
    sudo ssh-keygen -t rsa -q -N "" -f ~/.ssh/id_rsa
    key_value=$(<~/.ssh/id_rsa.pub)
fi

for var in subscription_id resource_group vault_name key_name key_value
do
    : "${!var:?"Argument $var is not set or null/empty"}"
done

# install Azure CLI 2.0 on Ubuntu
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli

# login using msi 
az login -u ${subscription_id}@${port}

# write key as a secret to vault
az keyvault secret set --vault-name ${vault_name} --name ${key_name} --value "${key_value}"

# DEBUG -- dump results
#az keyvault secret show --vault-name ${vault_name} --name ${key_name}
#az keyvault secret download --file '~/rickvault.secret' --vault-name ${vault_name} --name ${key_name} 

