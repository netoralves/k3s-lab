# k3s-lab

## Virtual Environment:

|  Name                  |  OS                                  |       Type       |  vCPU  |  RAM  |  Storage  |  IP Address  |
|------------------------|--------------------------------------|------------------|--------|-------|-----------|--------------|
|     k3s-master     |  CentOS 7.9.2009  			|  Master,Etcd     |    1   |   1  |    40    |192.168.1.100 |
|     k3s-node01     |  CentOS 7.9.2009  			|  Worker(Node)    |    1   |   1  |    40    |192.168.1.101 |
|  k3s-node02        |  CentOS 7.9.2009  			|  Worker(Node)    |    1   |   1  |    40    |192.168.1.102 |

## How it Works
![](images/topology_k3s.png?raw=true)

Follow DOCS in [k3s.io](https://rancher.com/docs/k3s/latest/en/)

## Create infrastructure in your proxmox server
	root@pve-01:~/k3s-lab# ansible-playbook ansible/infrastructure/infrastructure_k3s.yml

## Deploy K3S Cluster


### Loging in k3s-master and execute basic-script.sh to prepare environment
	[k3s@k3s-master ~]$ sudo yum install git sshpass
	[k3s@k3s-master ~]$ sudo -i
	[root@k3s-master ~]# git clone https://github.com/netoralves/k3s-lab.git
	[root@k3s-master ~]# cd k3s-lab
	[root@k3s-master k3s-lab]# chmod +x basic-config.sh
	[root@k3s-master k3s-lab]# ./basic-config.sh

### Validate the access
	[k3s@k3s-master ~]$ ssh k3s-node01
	Last login: Mon Apr 26 09:59:16 2021 from k3s-master.ocp.local
	[k3s@k3s-node01 ~]$ logout
	Connection to k3s-node01 closed.
	[k3s@k3s-master ~]$ ssh k3s-node02
	Last login: Mon Apr 26 09:59:19 2021 from k3s-master.ocp.local
	[k3s@k3s-node02 ~]$ logout
	Connection to k3s-node02 closed.
	[k3s@k3s-master ~]$ 

### 
	
