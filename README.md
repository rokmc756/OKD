## What is this Ansible Playbook for OKD
It is Ansible Playbook to deploy OKD for Rocky/CentOS 9.x. The purpose of this is only for development environment not production.

## What is OKD?
OKD is the community distribution of Kubernetes optimized for continuous application development and multi-tenant deployment. It adds developer and operational-centric tools on top of Kubernetes, enabling rapid application development, easy deployment and scaling, and long-term lifecycle maintenance.

## OKD Installation Target and Dependencies
![alt text](https://raw.githubusercontent.com/rokmc756/okd/main/roles/okd/images/okd-installation-target.png)

## OKD Architecture
![alt text](https://raw.githubusercontent.com/rokmc756/okd/main/roles/okd/images/okd-architecture-overview.png)

## Build and Deployment Containers
![alt text](https://raw.githubusercontent.com/rokmc756/okd/main/roles/okd/images/building-container.png)
- https://docs.okd.io/4.10/architecture/understanding-development.html


## Supported Platform and OS
Virtual Machines\
Baremetal\
CentOS Stream 9.x

## Prerequisite for Ansible Host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt

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
### Download OKD Software Binaries to Ansible Files Directory
```
$ make download

$ ls -al roles/okd/files/
openshift-client-linux-4.17.0-okd-scos.0.tar.gz openshift-install-linux-4.17.0-okd-scos.0.tar.gz ccoctl-linux-4.17.0-okd-scos.0.tar.gz
```
### Setup DNS with FreeIPA
#### 1) Configure Varialbes for DNS Zone and Records
```
$ vi roles/okd/var/main.yml
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

#### 2) Add DNS Zones and Records
```
$ make okd r=setup s=dns c=zone
$ make okd r=setup s=dns c=record
or
$ make okd r=setup s=dns c=all
```

#### 3) Remove DNS Zones and Records
```yaml
$ make okd r=remove s=dns c=record
$ make okd r=remove s=dns c=zone
or
$ make okd r=remove s=dns c=all
```

###  Setup Network with Resolved or DNSMasq for Manager Node
#### 1) Configure Network Inventory for Manager Node
```
$ vi ansible-hosts-co9-network
~~ snip
[manager]
mgr             ansible_ssh_host=192.168.2.171

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
```

#### 2) Setup Network with Resolved for Manager Node
```
$ make okd r=setup s=network c=resolved
or
$ make okd r=setup s=network c=dnsmasq
```

#### 3) Setup Network with DNSMasq for Manager Node
```
$ make okd r=remove s=network c=dnsmasq
or
$ make okd r=remove s=network c=resolved
```

### Setup OKD Manager Node
#### 1) Configure Inventory for OKD Manager Node
```
$ vi ansible-hosts-co9-mgr
~~ snip
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

#### 3) Setup OKD Install Clients
```
$ make okd r=setup s=client
```

#### 4) Destroy OKD Manager Node
```
$ make okd r=destroy s=mgr
```

### Deploy OKD BootStrap Node
#### 1) Configure Inventory for OKD BootStrap Node
```
$ vi ansible-hosts-co9-bootstrap
~~ snip
[manager]
mgr             ansible_ssh_host=192.168.2.171

[_bootstrap]
bootstrap       ansible_ssh_host=192.168.2.172

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
~~ snip
```

#### 2) Deploy OKD BootStrap Node
```
$ make okd r=deploy s=bootstrap
```

#### 3) Rollback Centos After Removing Customer Boot Loader
```
$ make okd r=rollback s=bootstrap c=centos
```

### Deploy OKD Master Nodes
#### 1) Configure Inventory for OKD Master Nodes
```yaml
$ vi ansible-hosts-co9-master
~~ snip
[manager]
mgr             ansible_ssh_host=192.168.2.171

[compute]
worker-1        ansible_ssh_host=192.168.2.176
worker-2        ansible_ssh_host=192.168.2.177

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
~~ snip
```

#### 2) Deploy OKD Master Nodes
```yaml
$ make okd r=deploy s=master
```

### Deploy OKD Worker Nodes
#### 1) Configure Inventory for OKD Worker Nodes
```
$ vi ansible-hosts-co9-master
~~ snip
[manager]
mgr             ansible_ssh_host=192.168.2.171

[compute]
worker-1        ansible_ssh_host=192.168.2.176
worker-2        ansible_ssh_host=192.168.2.177

[dns]
rk9-freeipa     ansible_ssh_host=192.168.2.199
```

#### 2) Deploy OKD Worker Nodes
```yaml
$ make okd r=deploy s=worker
```

## References
- https://medium.com/@tcij1013/installing-okd-the-community-distribution-of-kubernetes-4-x-cluster-on-a-single-node-8410146858b6
- https://qiita.com/sawa2d2/items/3cf9c9d5d9ce5f589124
- https://www.linuxsysadmins.com/okd-cluster-openshift-installation/
- https://gruuuuu.github.io/ocp/ocp4-install-baremetal/#


## Similar Playbook
## TODO
## Debugging
## Tracking Issues
- https://github.com/coreos/fedora-coreos-tracker/issues/94

