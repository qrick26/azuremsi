#!/bin/bash

# add ssh key
sudo mkdir -p ~/.ssh
sudo echo $1 >> ~/.ssh/authorized_keys
sudo chmod 700 ~/.ssh
sudo chmod 640 ~/.ssh/authorized_keys

