#!/bin/bash

if [ "$(hostname -s)" != "k3s-master" ]; then
    echo "This script must be executed on host k3s-master"
    exit 1
fi

if [ "$(whoami)" != "root" ]; then
    echo "This script must be executed as root user"
    exit 1
fi

#VARIABLES

#==============================
#MASTERS
MASTER="k3s-master"
NODE01="k3s-node01"
NODE02="k3s-node02"
#==============================

USER="k3s"
USER_PASS="k3s"
ROOT_PASS="conecta"

# ADD A USER AND GRANT PRIVILEGIES
#MASTER
useradd -G root $USER
(echo $USER_PASS ; echo $USER_PASS ) | passwd $USER &>/dev/null
echo "%$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

echo "[GENERATE SSH KEY] - Please Press <ENTER>"
su -c "ssh-keygen -N ''" - $USER

echo "REMOVE ACCESS PERMISSION ON DIRECT ROOT LOGIN"
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

echo "COPY SSH KEY"
su -c "sshpass -p $USER_PASS ssh-copy-id -o 'StrictHostKeyChecking no' $MASTER" - $USER

for host in $NODE01 $NODE02;
do
echo "CREATE A CONFIG FROM USER $USER ON $host"
sshpass -p $ROOT_PASS ssh -o StrictHostKeyChecking=no root@$host "echo '%"$USER" ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER && ( echo $USER_PASS ; echo $USER_PASS ) | passwd $USER &>/dev/null && sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config"

echo "COPY SSH KEY FROM $MASTER TO $host"
su -c "sshpass -p $USER_PASS ssh-copy-id -o StrictHostKeyChecking=no $host" - $USER

# INSTALL KUBELET
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "UPDATE PACKAGES ON $host"
su -c "ssh $host -o StrictHostKeyChecking=no sudo yum -y update; yum install -y kubelet" - $USER
done

# INSTALL KUBELET
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# INSTALL BASIC PACKS
yum -y update
yum -y install vim kubelet ansible
