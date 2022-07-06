## Training plan 

<img src="plan.png">

### webapps in single docker image 

<img src="webapp.png">

### app clone 

```
384  git clone https://github.com/microsoft/project-html-website.git
  385  git clone https://github.com/schoolofdevops/html-sample-app.git
```

### Dockerfile 

```
FROM oraclelinux:8.4
LABEL name=ashutoshh
ENV deploy=webapp 
RUN yum install httpd -y ; mkdir -p /common/{app1,app2}
COPY html-sample-app /common/app1/
ADD  project-html-website  /common/app2/
COPY deploy.sh /common/
WORKDIR /common
RUN chmod +x deploy.sh
ENTRYPOINT  ["./deploy.sh"] 
#CMD ["./deploy.sh"]
# CMD is to define default process for container 


```

### .dockerignore 

```
html-sample-app/.git
html-sample-app/*.txt
project-html-website/.git
project-html-website/LICENSE
project-html-website/README.md

```

### shell script as container parent process 

```
#!/bin/bash

if  [  "$deploy" ==  "webapp1"  ]
then
    cp -rf /common/app1/*  /var/www/html/
    httpd -DFOREGROUND 
elif [  "$deploy" ==  "webapp2"  ]
then
    cp -rf /common/app2/*  /var/www/html/
    httpd -DFOREGROUND 
else 
    echo "You need to check Env variable value .." >/var/www/html/index.html
    httpd -DFOREGROUND
fi 
```

### docker compose 

```
version: "3.8"
services:
  ashuapp1:
    image: ashucustomer:v1
    build: .
    container_name: ashuc1
    ports:
    - "1234:80"
    environment:
      deploy: webapp2
    restart: always 
```

### running compose 

```
[ashu@docker-server ashu_customer1]$ ls
deploy.sh  docker-compose.yaml  Dockerfile  html-sample-app  project-html-website
[ashu@docker-server ashu_customer1]$ docker-compose up -d --build 
[+] Building 57.4s (12/12) FINISHED                                                              
 => [internal] load build definition from Dockerfile                                        0.0s
 => => transferring dockerfile: 485B                                                        0.0s
 => [internal] load .dockerignore                                                           0.0s
 => => transferring context: 230B                                                           0.0s
 => [internal] load metadata for docker.io/library/oraclelinux:8.4                          1.2s
 => [1/7] FROM docker.io/library/oraclelinux:8.4@sha256:b81d5b0638bb67030b207d28586d0e714a  6.4s
 => => resolve docker.io/library/oraclelinux:8.4@sha256:b81d5b0638bb67030b207d28586d0e714a  0.0s
 => => sha256:b81d5b0638bb67030b207d28586d0e714a811cc612396dbe3410db406998b3ad 547B / 547B  0.0s
 => => sha256:ef0327c1a51e3471e9c2966b26b6245bd1f4c3f7c86d7edfb47a39adb446ceb5 529B / 529B  0.0s
 => => sha256:97e22ab49eea70a5d500e00980537605d56f30f9614b3a6d6c4ae9ddbd64 1.48kB / 1.48kB  0.0s
 => => sha256:a4df6f21af842935f0b80f5f255a88caf5f16b86e2642b468f83b89766 90.36MB / 90.36MB  2.4s
 => => extracting sha256:a4df6f21af842935f0b80f5f255a88caf5f16b86e2642b468f83b8976666c3d7   3.7s
 => [internal] load build context                                                           0.0s
 => => transferring context: 2.88MB                                                         0.0s
 => [2/7] RUN yum install httpd -y ; mkdir -p /common/{app1,app2}                          43.0s
 => [3/7] COPY html-sample-app /common/app1/                                                0.5s 
 => [4/7] ADD  project-html-website  /common/app2/                                          0.1s 
 => [5/7] COPY deploy.sh /common/                                                           0.2s 
 => [6/7] WORKDIR /common                                                                   0.0s 
 => [7/7] RUN chmod +x deploy.sh                                                            2.0s 
 => exporting to image                                                                      4.0s
 => => exporting layers                                                                     4.0s
 => => writing image sha256:e90ac2045e84854258012f3ab46630ed8552923231d0d1c4e3441185c2299e  0.0s
 => => naming to docker.io/library/ashucustomer:v1                                          0.0s
[+] Running 2/2
 ⠿ Network ashu_customer1_default  Created                                                  0.6s
 ⠿ Container ashuc1                Started
```

### k8s for pod YAML 

```
kubectl run  ashucustomerpod --image=docker.io/dockerashu/ashucustomer:v1  --port 80   --dry-run=client -o yaml  >customer.yaml
```

### final YAML for webapp2 

<img src="web1.png">


### deploy YAML 

```
[ashu@docker-server k8s_app_deploy]$ kubectl apply -f  customer.yaml 
pod/ashucustomerpod created
[ashu@docker-server k8s_app_deploy]$ kubectl  get  po 
NAME              READY   STATUS              RESTARTS   AGE
ashucustomerpod   0/1     ContainerCreating   0          3s
[ashu@docker-server k8s_app_deploy]$ kubectl  get  po 
NAME              READY   STATUS    RESTARTS   AGE
ashucustomerpod   1/1     Running   0          14s
[ashu@docker-server k8s_app_deploy]$ kubectl  get  po -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP                NODE    NOMINATED NODE   READINESS GATES
ashucustomerpod   1/1     Running   0          20s   192.168.166.183   node1   <none>           <none>
[ashu@docker-server k8s_app_deploy]$ 


```

### networking in k8s 

<img src="net.png">


### container networking models 

<img src="model.png">

### checking pod ip and CNI details 

<img src="cnid.png">

### pod ipaddress usage number 1 

```
[ashu@docker-server k8s_app_deploy]$ kubectl  get  po -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP                NODE    NOMINATED NODE   READINESS GATES
ashucustomerpod   1/1     Running   0          22m   192.168.166.183   node1   <none>           <none>
[ashu@docker-server k8s_app_deploy]$ kubectl  run nettest --image=alpine --command sleep 10000 
pod/nettest created
[ashu@docker-server k8s_app_deploy]$ kubectl  get po -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP                NODE    NOMINATED NODE   READINESS GATES
ashucustomerpod   1/1     Running   0          23m   192.168.166.183   node1   <none>           <none>
nettest           1/1     Running   0          5s    192.168.104.50    node2   <none>           <none>
[ashu@docker-server k8s_app_deploy]$ kubectl  exec -it nettest -- sh 
/ # ping 192.168.166.183
PING 192.168.166.183 (192.168.166.183): 56 data bytes
64 bytes from 192.168.166.183: seq=0 ttl=62 time=0.533 ms
64 bytes from 192.168.166.183: seq=1 ttl=62 time=0.361 ms
^C
--- 192.168.166.183 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.361/0.447/0.533 ms
/ # exit
```





