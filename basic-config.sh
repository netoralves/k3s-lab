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
#K3S_CLUSTER
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

echo "UPDATE PACKAGES ON $host"
su -c "ssh $host -o StrictHostKeyChecking=no sudo yum -y update" - $USER
done

# INSTALL BASIC PACKS
yum -y update
yum -y install vim centos-release-ansible-29 ansible

# BACKUP ANSIBLE
rsync -zvh /etc/ansible/hosts /etc/ansible/hosts_backup$(date '+%Y%m%d%H%M%S')
rsync -zvh /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg_backup$(date '+%Y%m%d%H%M%S')

# CUSTOM FILE ANSIBLE
rsync -zvh /root/k3s-lab/ansible/k3s/templates/hosts /etc/ansible/hosts
rsync -zvh /root/k3s-lab/ansible/k3s/templates/ansible.cfg /etc/ansible/ansible.cfg

# ROLES AND PLAYBOOKS CONFIG TO INSTALLATION
rsync -a /root/k3s-lab/ansible/k3s/roles/ /etc/ansible/roles
rsync -a /root/k3s-lab/ansible/k3s/group_vars /etc/ansible/
rsync -zvh /root/k3s-lab/ansible/k3s/deploy.yml /etc/ansible/deploy.yml

# GRANT PRIVILEGIES
chown k3s:k3s /etc/ansible -R
