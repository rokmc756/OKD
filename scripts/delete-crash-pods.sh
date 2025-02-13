
for line in `kubectl get pods -A | grep -E "CrashLoopBack|Pending" | sed 1d | awk '{print $1","$2}'`
do

    NS=$(echo $line | cut -d , -f 1)
    POD=$(echo $line | cut -d , -f 2)

    echo $NS
    kubectl -n $NS delete pod/$POD

done

