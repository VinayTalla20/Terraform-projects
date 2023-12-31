#!/bin/sh  

echo "[TASK 1] Pull required containers"
sudo su
kubeadm config images pull >/dev/null 2>&1


echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init   >> /root/kubeinit.log 2>/dev/null

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > joincluster.sh 2>/dev/null

kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/calico.yaml
