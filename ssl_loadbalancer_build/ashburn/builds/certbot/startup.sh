#!/bin/bash

# Install snap
sudo yum install snap

# Install Certbot
sudo snap install --classic certbot

# Create a symbolic link to the certbot command ( Prepare the Certbot command )
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Temporarily spin up a webserver on your machine.
sudo certbot certonly --standalone