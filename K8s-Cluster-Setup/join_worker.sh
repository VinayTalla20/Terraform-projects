#!/bin/sh

# get kubeadm join commad from master
sudo su
apt install -qq sshpass -y
sleep 10
echo "ssh to master with IPAddress ${MASTER_IPADDRESS}"
sshpass -p "terraformuser" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no terraformuser@$MASTER_IPADDRESS:/home/terraformuser/joincluster.sh .
chmod +x joincluster.sh
sh joincluster.sh
