rm -f /etc/grub.d/40_custom

grub2-mkconfig -o /boot/grub2/grub.cfg

for nb in $(echo 'nvme0n1 nvme0n2'); do nvme format --ses=1 /dev/$nb --force ;done
for nb in $(echo 'nvme0n1 nvme0n2'); do wipefs -a /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2'); do sgdisk --zap-all /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2'); do dd if=/dev/zero of=/dev/$nb bs=10M count=10 oflag=direct,dsync ;done
for nb in $(echo 'nvme0n1 nvme0n2'); do blkdiscard /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2'); do partprobe /dev/$nb ;done

reboot
