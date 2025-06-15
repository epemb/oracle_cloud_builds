#!/bin/bash

# Add EPEL repo
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf upgrade -y

# Install snap service
sudo dnf install -y snapd

# Enable and start snap service
sudo systemctl enable --now snapd.socket
sudo systemctl start snapd

# Create symbolic link for snap
sudo ln -s /var/lib/snapd/snap /snap

# Install and refresh core service
sudo snap install core
sudo snap refresh core

# Install Certbot
sudo snap install --classic certbot

# Create a symbolic link to the certbot command ( Prepare the Certbot command )
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Temporarily spin up a webserver on your machine.
sudo certbot certonly --standalone