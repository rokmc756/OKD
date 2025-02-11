for i in `seq 1 7`
do

    sudo ping -c 1 192.168.2.17$i
    nc -vz 192.168.2.17$i 22
    ssh-keyscan 192.168.2.17$i
    # ssh-keyscan 192.168.2.17$i >/dev/null 2>&1

done

