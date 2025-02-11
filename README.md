## What is this Ansible Playbook for OKD
It is Ansible Playbook to deploy OKD for Rocky/CentOS 9.x. The purpose of this is only for development environment not production.

## OKD Architecutre


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
$ vi ansible-hosts-co9-mgr
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
$ vi ansible-hosts-co9-bootstrap
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
$ vi ansible-hosts-co9-master
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

#### Configure Varialbes for DNS Zone and Records
$ vi roles/okd/var/main.yml
```
---
_dns:
  zone:
    - { name: okd4.pivotal.io, type: forward }
    - { name: 2.168.192.in-addr.arpa, type: reverse }
  resource:
    forward:
      - {  name: "api",        zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.171"  }
      - {  name: "api-int",    zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.171"  }
      - {  name: "bootstrap",  zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.172"  }
      - {  name: "master-1",   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.173"  }
      - {  name: "etcd-1",     zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.173"  }
      - {  name: "master-2",   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.174"  }
      - {  name: "etcd-2",     zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.174"  }
      - {  name: "master-3",   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.175"  }
      - {  name: "etcd-3",     zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.175"  }
      - {  name: "worker-1",   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.176"  }
      - {  name: "worker-2",   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.177"  }
      - {  name: "_etcd-server-ssl._tcp",  zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.173"  }
      - {  name: "_etcd-server-ssl._tcp",  zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.174"  }
      - {  name: "_etcd-server-ssl._tcp",  zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.175"  }
    reverse:
      - { name: "171",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "api.okd4.pivotal.io."  }
      - { name: "171",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "api-int.okd4.pivotal.io."  }
      - { name: "172",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "bootstrap.okd4.pivotal.io."  }
      - { name: "173",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "master-1.okd4.pivotal.io."  }
      - { name: "173",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "etcd-1.okd4.pivotal.io."  }
      - { name: "174",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "master-2.okd4.pivotal.io."  }
      - { name: "174",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "etcd-2.okd4.pivotal.io."  }
      - { name: "175",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "master-3.okd4.pivotal.io."  }
      - { name: "175",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "etcd-3.okd4.pivotal.io."  }
      - { name: "173",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "_etcd-server-ssl.tcp.okd4.pivotal.io."  }
      - { name: "174",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "_etcd-server-ssl.tcp.okd4.pivotal.io."  }
      - { name: "175",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "_etcd-server-ssl.tcp.okd4.pivotal.io."  }
      - { name: "176",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "worker-1.okd4.pivotal.io."  }
      - { name: "177",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "worker-2.okd4.pivotal.io."  }
```

#### Add DNS Zones and Records
```
$ make okd r=setup s=dns c=zone
$ make okd r=setup s=dns c=record

or
$ make okd r=setup s=dns c=all
```

#### Remove DNS Zones and Records
```
$ make okd r=remove s=dns c=record
$ make okd r=remove s=dns c=zone

or
$ make okd r=remove s=dns c=all
```


### Setup Network with Resolved or DNSMasq for Manager Node
#### 1) Configure Varialbes for DNS Zone and Records
$ vi ansible-hosts-co9-network
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[manager]
mgr             ansible_ssh_host=192.168.2.171

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
```
#### 2) Setup Network with Resolved or DNSMasq
```
$ make okd r=setup s=network c=resolved
or
$ make okd r=setup s=network c=dnsmasq
```
#### 3) Remove Network with Resolved or DNSMasq
```
$ make okd r=remove s=network c=dnsmasq
or
$ make okd r=remove s=network c=resolved
```


### Setup OKD Manager Node
#### 1) Configure Inventory for OKD Manager Node
$ vi ansible-hosts-co9-mgr
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[manager]
mgr             ansible_ssh_host=192.168.2.171

[_bootstrap]
bootstrap       ansible_ssh_host=192.168.2.172

[master]
master-1        ansible_ssh_host=192.168.2.173
master-2        ansible_ssh_host=192.168.2.174
master-3        ansible_ssh_host=192.168.2.175

[compute]
worker-1        ansible_ssh_host=192.168.2.176
worker-2        ansible_ssh_host=192.168.2.177

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
```
#### 2) Deploy OKD Manager Node
```
$ make okd r=deploy s=mgr
```
#### 3) Deploy OKD Manager Node
```
$ make okd r=destroy s=mgr
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

