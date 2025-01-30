#!/bin/bash

# Login to IITB Internet SSO
curl --location-trusted -u raj.saroj:c2f30b3626e73eb33d675e8089f823 "https://internet-sso.iitb.ac.in/login.php" > /dev/null

sudo apt update
sudo apt upgrade -y
sudo apt install -y neofetch build-essential cmake git libopenmpi-dev openmpi-bin libboost-all-dev nfs-common stress-ng

# Install OpenFOAM dependencies
sudo apt install -y libscotch-dev libptscotch-dev
sudo sh -c "wget -O - https://dl.openfoam.org/gpg.key > /etc/apt/trusted.gpg.d/openfoam.asc"
sudo add-apt-repository http://dl.openfoam.org/ubuntu
sudo apt update

# Create mount point and configure NFS
sudo mkdir /clustershare
sudo nano /etc/fstab # (Add NFS share details manually)
sudo mount -a

# Install OpenFOAM
sudo apt install -y openmpi-bin openmpi-common libopenmpi-dev
sudo ln -s /clustershare/openfoam9 /opt/openfoam9

# Configure OpenFOAM environment
echo 'source /clustershare/openfoam9/etc/bashrc' >> ~/.bashrc
source ~/.bashrc

# Setup SSH keys for passwordless login
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh-copy-id simumaster
ssh-copy-id simunode1

# Configure hostfile for parallel execution
nano hostfile  # (Edit hostfile with the proper node information)

# Verify OpenFOAM setup
icoFoam -help

# Set timezone
timedatectl set-timezone Asia/Kolkata
date

# Reboot the node
sudo reboot

# Final setup - Run tests
cd /clustershare/
icoFoam -parallel -fileHandler collated

# End of setup
echo "Cluster node setup complete!"
