#!/bin/bash

# The default port for the MSI extension is 50342

if [ -z $PORT ]; then
    PORT=50342
fi

for var in SUBSCRIPTION_ID RESOURCE_GROUP VAULT_NAME KEY_NAME KEY_VALUE
do

    if [ -z ${!var} ]; then
        echo "Argument $var is not set" >&2
        exit 1
    fi

done

# login using msi 

az login -u ${SUBSCRIPTION_ID}@${PORT}

# add ssh key
mkdir -p ~/.ssh
echo ${KEY_VALUE} >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 640 ~/.ssh/authorized_keys

