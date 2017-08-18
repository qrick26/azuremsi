#!/bin/bash

while getopts ":i:s:a:c:r:v:k:u:p:t:" opt; do
  case $opt in
    i) docker_image="$OPTARG"
    ;;
    s) subscription_id="$OPTARG"
    ;;
    a) storage_account="$OPTARG"
    ;;
    c) container_name="$OPTARG"
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
    t) script_file="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z $docker_image ]; then
    docker_image="azuresdk/azure-cli-python:latest"
fi

if [ -z $script_file ]; then
    script_file="writeblob.sh"
fi

for var in storage_account subscription_id resource_group
do

    if [ -z ${!var} ]; then
        echo "Argument $var is not set" >&2
        exit 1
    fi 

done

# Install Docker and then run docker image with cli

sudo apt-get -y update
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce
sudo docker run -v `pwd`:/scripts --network='host' \
-e SUBSCRIPTION_ID=${subscription_id} \
-e STORAGE_ACCOUNT=${storage_account} \
-e CONTAINER_NAME=${container_name} \
-e RESOURCE_GROUP=${resource_group} \
-e VAULT_NAME=${vault_name} \
-e KEY_NAME=${key_name} \
-e KEY_VALUE=${key_value} \
-e PORT=${PORT} \
${docker_image} "./scripts/${script_file}" 