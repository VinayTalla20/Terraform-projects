#!/bin/sh

# get kubeadm join commad from master
apt install -qq sshpass -y
sshpass -p "terraformuser" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no terraformuser@$MASTER_IPADDRESS:home/terraformuser/joincluster.sh /joincluster.sh 2>/dev/null
chmod +x joincluster.sh
sh joincluster.sh
