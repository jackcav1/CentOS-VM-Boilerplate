#!/bin/bash

//DISTR=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

//*if [[ $DISTR != "CentOS Linux" ]]; then
  echo "No action taken..."
  echo "Are you sure this is a CentOS system?"
  exit 1
*//fi

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    fi
if [ $OS != "CentOS Linux" ]; then
  echo "No action taken..."
  echo "Are you sure this is a CentOS system?"
  exit 1

if [[ $EUID -ne 0 ]]; then
  echo "No action taken..."
  echo "This script must be run as root"
  exit 1
fi

read -p "Enter desired hostname: " newHostname

echo "Generating new Machine ID"
rm -f /etc/machine-id
systemd-machine-id-setup
echo "Machine ID:"
cat /etc/machine-id

echo "Generating SSH server keys"
ssh-keygen -t rsa

echo "Setting Hostname"
hostnamectl set-hostname $newHostname

echo "Done!"

read -p "Would you like to reboot the system now? [Y/N]: " confirm &&
  [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

reboot
exit 0
