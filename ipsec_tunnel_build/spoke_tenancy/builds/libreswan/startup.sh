#!/bin/bash

# Add EPEL repo
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf upgrade -y

# Install snap service
sudo dnf install -y snapd

# Enable and start snap service
sudo systemctl enable --now snapd.socket
sudo systemctl start snapd
