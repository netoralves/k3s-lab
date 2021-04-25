# k3s-lab

## Create infrastructure in your proxmox server
	root@pve-01:~/k3s-lab# ansible-playbook ansible/infrastructure/infrastructure_k3s.yml
kernel?  [http://ftp.byfly.by/pub/CentOS/7/os/x86_64/isolinux/vmlinuz]:
initrd?  [http://ftp.byfly.by/pub/CentOS/7/os/x86_64/isolinux/initrd.img]:
Kickstart URL?  [https://raw.githubusercontent.com/netoralves/k3s-lab/main/ansible/infrastructure/ks/anaconda-ks.cfg]:
PVE API host?  [192.168.0.200]:

PLAY [Create Infrastructure for K3S - Dev Environment] *********************************************************

TASK [Create VMs] **********************************************************************************************
changed: [localhost] => (item={u'mac': u'82:58:ee:49:31:48', u'name': u'k3s-master'})
changed: [localhost] => (item={u'mac': u'92:5d:d1:b3:13:1a', u'name': u'k3s-node01'})
changed: [localhost] => (item={u'mac': u'56:f5:0f:1b:9f:14', u'name': u'k3s-node02'})

TASK [Fetch kernel] ********************************************************************************************
changed: [localhost -> 192.168.0.200]

TASK [Fetch initrd] ********************************************************************************************
changed: [localhost -> 192.168.0.200]

TASK [Wait for kernel] *****************************************************************************************
ok: [localhost -> 192.168.0.200]

TASK [Wait for initrd] *****************************************************************************************
ok: [localhost -> 192.168.0.200]

TASK [include] *************************************************************************************************
included: /root/k3s-lab/ansible/infrastructure/deploy_k3s_vms.yml for localhost => (item=k3s-master)
included: /root/k3s-lab/ansible/infrastructure/deploy_k3s_vms.yml for localhost => (item=k3s-node01)
included: /root/k3s-lab/ansible/infrastructure/deploy_k3s_vms.yml for localhost => (item=k3s-node02)

TASK [Deploy VM] ***********************************************************************************************
changed: [localhost]

TASK [Get VMID] ************************************************************************************************
ok: [localhost]

TASK [Set VMID] ************************************************************************************************
ok: [localhost]

TASK [Waiting install finish] **********************************************************************************
Pausing for 600 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
