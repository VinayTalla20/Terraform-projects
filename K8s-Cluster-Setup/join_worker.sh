#!/bin/sh

# get kubeadm join commad from master
sudo su
apt install -qq sshpass -y
sleep 30
sshpass -p "terraformuser" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no terraformuser@$MASTER_IPADDRESS:/home/terraformuser/joincluster.sh . 2>/dev/null
chmod +x joincluster.sh
sh joincluster.sh
