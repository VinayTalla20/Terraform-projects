#!/bin/sh  

echo "[TASK 0] Set SSH user and password"
# add new user and set password
sudo su
sudo useradd -m terraformuser
echo "terraformuser\nterraformuser" | passwd terraformuser >/dev/null 2>&1
sudo usermod --shell /bin/bash terraformuser


# Enable password authencation using ssh
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
sleep 5


echo "[TASK 1] Pull required containers"
sudo su
kubeadm config images pull >/dev/null 2>&1


echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init   >> /root/kubeinit.log 2>/dev/null

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > joincluster.sh 2>/dev/null
cp joincluster.sh  /home/terraformuser/
chown terraformuser:root /home/terraformuser/joincluster.sh

kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/calico.yaml
