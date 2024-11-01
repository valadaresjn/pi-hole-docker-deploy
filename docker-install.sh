#!/bin/bash

# Uninstall all conflicting packages
echo "Uninstalling conflicting packages"
snap remove docker
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
apt autoremove
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt remove $pkg; done


# Add Docker's official GPG key:
echo "Adding Docker's official GPG key"
apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "Adding repository to Apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

# Install the latest version
echo "Installing the latest version"
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verifiing port conflicting
echo "Verifiing port conflicting"
lsof -i -P -n | grep LISTEN

# If some service It's already using port 53 remove with the folowing commands
echo "If some service It's already using port 53 remove it with the folowing commands"
echo "systemctl disable service_name"
echo "systemctl stop service_name"