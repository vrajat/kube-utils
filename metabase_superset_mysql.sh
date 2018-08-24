kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl port-forward $K8S_DASH 8443:8443 --namespace=kube-system
kubectl proxy &



helm init
helm install --name superset stable/superset
helm install --name metabase stable/metabase
helm install --name mysql --set mysqlRootPassword=supersecretpassword,mysqlUser=superuser,mysqlPassword=superpwd,mysqlDatabase=superdb stable/mysql


export METABASE_POD=$(kubectl get pods --namespace default -l "app=metabase,release=metabase" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace default $METABASE_POD 8080:3000 &

export SUPERSET_POD=$(kubectl get pods --namespace default -l "app=superset,release=superset" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $SUPERSET_POD 8088:8088 &

export MYSQL_POD=$(kubectl get pods --namespace default -l "app=mysql" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $MYSQL_POD 3306:3306 &

echo "Access dashboard: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
echo "Access metabase: http://localhost:8080"
echo "Access superset: http://localhost:8088"

