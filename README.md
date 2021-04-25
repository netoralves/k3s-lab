# k3s-lab

## Virtual Environment:

|  Name                  |  OS                                  |       Type       |  vCPU  |  RAM  |  Storage  |  IP Address  |
|------------------------|--------------------------------------|------------------|--------|-------|-----------|--------------|
|     k3s-master     |  CentOS 7.9.2009  			|  Master,Etcd     |    1   |   1  |    40    |192.168.1.100 |
|     k3s-node01     |  CentOS 7.9.2009  			|  Worker(Node)    |    1   |   1  |    40    |192.168.1.101 |
|  k3s-node02        |  CentOS 7.9.2009  			|  Worker(Node)    |    1   |   1  |    40    |192.168.1.102 |

# How it Works
![](images/topology_k3s.png?raw=true)

Follow DOCS in [k3s.io](https://rancher.com/docs/k3s/latest/en/)

## Create infrastructure in your proxmox server
	root@pve-01:~/k3s-lab# ansible-playbook ansible/infrastructure/infrastructure_k3s.yml

## Deploy K3S Cluster
