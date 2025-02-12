#### Install Btrfs
~~~
sudo dnf update
sudo reboot
sudo dnf install https://cbs.centos.org/kojifiles/packages/centos-release-kmods/2/4.el9s/noarch/centos-release-kmods-2-4.el9s.noarch.rpm
sudo dnf install kmod-btrfs-5.14.0.45-2.el9s.x86_64
sudo modprobe btrfs
sudo mkfs.btrfs /dev/vdb
sudo mount /dev/vdb /mnt

