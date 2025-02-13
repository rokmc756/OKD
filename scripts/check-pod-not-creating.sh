
for line in `kubectl get pods -A | grep -v Running | grep -v Completed | sed 1d | awk '{print $1","$2}'`
do

    NS=$(echo $line | cut -d , -f 1)
    POD=$(echo $line | cut -d , -f 2)

    kubectl -n $NS describe pod/$POD
    kubectl -n $NS logs pod/$POD

done

