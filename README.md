## Training plan 

<img src="plan.png">

### clean namespace data 

```
[ashu@docker-server images]$ kubectl  delete all --all
pod "ashuwebapp-7d9ff7df76-2fcp9" deleted
pod "ashuwebapp-7d9ff7df76-nfxpl" deleted
pod "ashuwebapp-7d9ff7df76-qr676" deleted
service "ashu-local-lb" deleted
deployment.apps "ashuwebapp" deleted
horizontalpodautoscaler.autoscaling "ashuwebapp" deleted

```

###

```
[ashu@docker-server images]$ kubectl  delete  cm,secret  --all
configmap "ashucm" deleted
configmap "kube-root-ca.crt" deleted
secret "ashu-sec" deleted
secret "ashuapp-sec" deleted
```

## deploy database --

### creating configmap 

```
apiVersion: v1
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: ashudb-cm
data:
  MYSQL_USER: oracle
  MYSQL_DATABASE: mydb 

```

### creating secret to store info 

```
kubectl  create  secret  generic  db-cred  --from-literal  rootpw="Cisco@12345" --from-literal  upass="Docker@123456"  --dry-run=client -o yaml  >dbsecret.yaml


```

### deployment file 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashudb
  name: ashudb # name of deployment 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashudb
  strategy: {}
  template: # template section 
    metadata:
      creationTimestamp: null
      labels:
        app: ashudb
    spec:
      containers:
      - image: mysql
        name: mysql
        ports:
        - containerPort: 3306
        envFrom: # calling env and value directly 
        - configMapRef:
            name: ashudb-cm 
        env: # to call 
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-cred
              key: rootpw
        - name: MYSQL_PASSWORD 
          valueFrom:
            secretKeyRef:
              name: db-cred
              key: upass 
        resources: {}
status: {}

```

### lets deploy it 

```
[ashu@docker-server multi-tier-app]$ kubectl  apply -f . 
deployment.apps/ashudb created
configmap/ashudb-cm configured
secret/db-cred configured
[ashu@docker-server multi-tier-app]$ kubectl  get  cm 
NAME               DATA   AGE
ashudb-cm          2      7m20s
kube-root-ca.crt   1      40m
[ashu@docker-server multi-tier-app]$ kubectl  get  secret
NAME      TYPE     DATA   AGE
db-cred   Opaque   2      7m23s
[ashu@docker-server multi-tier-app]$ kubectl  get  deploy 
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
ashudb   1/1     1            1           4m53s
[ashu@docker-server multi-tier-app]$ kubectl  get  rs
NAME                DESIRED   CURRENT   READY   AGE
ashudb-779f468cfd   1         1         1       4m58s
[ashu@docker-server multi-tier-app]$ kubectl  get  po
NAME                      READY   STATUS    RESTARTS   AGE
ashudb-779f468cfd-2qv8d   1/1     Running   0          5m1s
```

### undertstanding storage in k8s 

<img src="st.png">







