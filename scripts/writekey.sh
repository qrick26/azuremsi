#!/bin/bash

# install Azure CLI 2.0 on Ubuntu
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli


# add ssh key
sudo mkdir -p ~/.ssh
sudo echo $1 >> ~/.ssh/authorized_keys
sudo chmod 700 ~/.ssh
sudo chmod 640 ~/.ssh/authorized_keys

