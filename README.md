## What is this Ansible Playbook for OKD
It is Ansible Playbook to deploy OKD for Rocky/CentOS 9.x
The purpose of this is only for development environment not production.

## OKD Architecutre
![alt text]()

## Supported Platform and OS
Virtual Machines\
Baremetal\
RHEL and CentOS 9 and Rocky Linux 9.x\

## Prerequisite for Ansible Host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt\

## Prepare Ansible Host to run this Ansible Playbook
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL
```
$ yum install ansible
```

## How to Deploy and Destroy OKD
### Configure Variables and Inventory with Hostnames, IP Addresses, sudo Username and Password
#### 1) Deploy OKD Manager
```
$ vi ansible-hosts-mgr
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[manager]
mgr             ansible_ssh_host=192.168.1.181

$ make okd r=install s=network
$ make okd r=install s=mgr
$ make okd r=install s=client
```

### 2) Deploy OKD BootStrap
```
$ vi ansible-hosts-bootstrap
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[bootstrap]
bootstrap01       ansible_ssh_host=192.168.1.182

$ make okd r=install s=bootstrap
```

### Deploy OKD Master
```
$ vi ansible-hosts-master
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[manager]
mgr             ansible_ssh_host=192.168.1.181

[master]
master01        ansible_ssh_host=192.168.1.183

$ make okd r=install s=master
```


#### Test
```
```

#### Test
```
```


## References
- https://www.pivert.org/deploy-openshift-okd-on-proxmox-ve-or-bare-metal-tutorial/
- https://stackoverflow.com/questions/65266545/okd-installation-behind-proxy
- https://qiita.com/sawa2d2/items/3cf9c9d5d9ce5f589124
- https://www.bookstack.cn/read/okd-4.12-en/14bea13e5cd9a170.md
- https://docs.okd.io/4.9/installing/installing_bare_metal/installing-bare-metal-network-customizations.html
~~~
Table 11. Optional parameters
Parameter	Description	Values
additionalTrustBundle

A PEM-encoded X.509 certificate bundle that is added to the nodes' trusted certificate store. This trust bundle may also be used when a proxy has been configured.
String
~~~
- https://www.linuxsysadmins.com/okd-cluster-openshift-installation/
- https://www.linuxsysadmins.com/okd-cluster-openshift-installation/
- https://docs.openshift.com/container-platform/4.8/architecture/architecture-rhcos.html
- https://gruuuuu.github.io/ocp/ocp4-install-baremetal/#



## Similar Playbook

## TODO

## Debugging

