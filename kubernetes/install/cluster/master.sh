#!/bin/bash

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install kubeadm -y
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube

sleep 10

if [[ $(kubectl get pods -n kube-system | grep -c Running ) != 6 ]]
then
    echo ERROR. Los pods del control plane no se están ejecutando correctamente
fi


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
#kubectl taint nodes --all node-role.kubernetes.io/master-

sleep 30


if [[ $(kubectl get pods -n kube-system | grep -c Running ) != 8 ]]
then
    echo ERROR. Los pods del control plane no se están ejecutando correctamente
fi