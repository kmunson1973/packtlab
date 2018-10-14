kubectl create -f /vagrant/packtlab/kube/serviceacct.yaml
kubectl create clusterrolebinding packt-admin --clusterrole=cluster-admin --user="system:serviceaccount:default:packt-admin"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
