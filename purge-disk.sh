
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do nvme format --ses=1 /dev/$nb --force ;done
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do wipefs -a /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do sgdisk --zap-all /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do dd if=/dev/zero of=/dev/$nb bs=10M count=10 oflag=direct,dsync ;done
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do blkdiscard /dev/$nb ;done
for nb in $(echo 'nvme0n1 nvme0n2 nvme0n3 nvme0n4'); do partprobe /dev/$nb ;done

