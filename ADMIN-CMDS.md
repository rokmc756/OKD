### Monitor the logs using oc:
~~~
$ oc adm node-logs --role=master -u kubelet
~~~


### Monitor the logs using oc:
~~~
$ oc adm node-logs --role=master -u crio
$ oc get etcd -o=jsonpath='{range .items[0].status.conditions[?(@.type=="EtcdMembersAvailable")]}{.message}{"\n"}'
~~~


### Checking Unhealthy ETCD
- https://docs.openshift.com/container-platform/4.9/backup_and_restore/control_plane_backup_and_restore/replacing-unhealthy-etcd-member.html
~~~
$ oc get nodes -l node-role.kubernetes.io/master | grep "NotReady"
$ oc -n openshift-etcd get pods -l k8s-app=etcd
$ oc rsh -n openshift-etcd etcd-etcd-1.okd4.pivotal.io
~~~

