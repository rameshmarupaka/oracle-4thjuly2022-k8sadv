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




