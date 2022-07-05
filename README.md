## Training plan 

<img src="plan.png">


### Info about POdman 

### OL8 based installation 

```
[root@podman ~]# dnf  install podman 
Ksplice for Oracle Linux 8 (x86_64)                                                           11 MB/s | 992 kB     00:00    
MySQL 8.0 for Oracle Linux 8 (x86_64)                                                         23 MB/s | 2.4 MB     00:00    
MySQL 8.0 Tools Community for Oracle Linux 8 (x86_64)                                        6.5 MB/s | 308 kB     00:00    
MySQL 8.0 Connectors Community for Oracle Linux 8 (x86_64)                                   521 kB/s |  23 kB     00:00    
Oracle Software for OCI users on Oracle Linux 8 (x86_64)                                      72 MB/s |  40 MB     00:00    
Oracle Linux 8 BaseOS Latest (x86_64)                                                         69 MB/s |  47 MB     00:00    
Oracle Linux 8 Application Stream (x86_64)                                                    72 MB/s |  37 MB     00:00    
Oracle Linux 8 Addons (x86_64)                                                                40 MB/s | 4.1 MB     00:00    
Latest Unbreakable Enterprise Kernel Release 6 for Oracle Linux 8 (x86_64)                    72 MB/s |  50 MB     00:00    
Dependencies resolved.
=============================================================================================================================
 Package                          Arch        Version                                           Repository              Size
=============================================================================================================================
Installing:
 podman                           x86_64      2:4.0.2-6.module+el8.6.0+20665+a3b29bef           ol8_appstream           13 M
Installing dependencies:
 conmon                           x86_64      2:2.1.0-1.module+el8.6.0+20665+a3b29bef           ol8_appstream           55 k
 container-selinux                noarch      2:2.179.1-1.module+el8.6.0+20665+a3b29bef         ol8_appstream           58 k
 containernetworking-plugins      x86_64      1:1.0.1-2.module+el8.6.0+20665+a3b29bef           ol8_appstream           18 M
 containers-common                x86_64      2:1-27.0.1.module+el8.6.0+20665+a3b29bef          ol8_appstream           67 k
 criu                             x86_64      3.15-3.module+el8.6.0+20665+a3b29bef              ol8_appstream          518 k
 fuse-common                      x86_6
```

### conf of podman 

```
[root@podman ~]# cd /etc/containers/
[root@podman containers]# ls
certs.d  oci  policy.json  registries.conf  registries.conf.d  registries.d  storage.conf
```

### podman --

```
[root@podman containers]# podman ps 
CONTAINER ID  IMAGE                            COMMAND      CREATED        STATUS            PORTS       NAMES
1a3a6337f224  docker.io/library/alpine:latest  ping fb.com  6 seconds ago  Up 6 seconds ago              x1
[root@podman containers]# podman network ls
NETWORK ID    NAME        DRIVER
2f259bab93aa  podman      bridge
[root@podman containers]# podman network inspect podman 
[
     {
          "name": "podman",
          "id": "2f259bab93aaaaa2542ba43ef33eb990d0999ee1b9924b557b7be53c0b7a1bb9",
          "driver": "bridge",
          "network_interface": "cni-podman0",
          "created": "2022-07-05T04:25:12.176604162Z",
          "subnets": [
               {
                    "subnet": "10.88.0.0/16",
                    "gateway": "10.88.0.1"
```

###  More container logics 

### Cgroups -- 

<img src="cgroups.png">

### Demo 1 

```
 docker  run -d --name ashudb1 -e MYSQL_ROOT_PASSWORD="Docker@123456"  mysql 
Unable to find image 'mysql:latest' locally
Trying to pull repository docker.io/library/mysql ... 
latest: Pulling from docker.io/library/mysql
824b15f81d65: Pull complete 
c559dd1913db: Pull complete 
e201c19614e6: Pull complete 
f4247e8f6125: Pull complete 
dc9fefd8cfb5: Pull complete 
af3787edd16d: Pull complete 
b6bb40f875d3: Pull complete 
75f6b647ddb1: Pull complete 
a09ca0f0cb24: Pull complete 
9e223e3cd2fd: Pull complete 
2b038d826c65: Pull complete 
d33ac6052fc9: Pull complete 
Digest: sha256:a840244706a5fdc3c704b15a3700bfda39fdc069262d7753fa09de2d9faf5f83
Status: Downloaded newer image for mysql:latest
d4dce6149ed6a961705c793a37d5b92fdc49fbaf1c6ec526624dd39729e90671
[ashu@docker-server images]$ docker  ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                 NAMES
28b67125f7b2        mysql               "docker-entrypoint.s…"   14 seconds ago      Up 13 seconds       3306/tcp, 33060/tcp   prddb1
d4dce6149ed6        mysql               "docker-entrypoint.s…"   38 seconds ago      Up 29 seconds       3306/tcp, 33060/tcp   ashudb1
[ashu@docker-server images]$ 
```

### check ip of container 

```
[ashu@docker-server images]$ docker  inspect  ashudb1  --format='{{.NetworkSettings.IPAddress}}'
172.17.0.2
```

### checking logs 

```
[ashu@docker-server images]$ docker logs   ashudb1
2022-07-05 04:39:25+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.29-1debian10 started.
2022-07-05 04:39:25+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2022-07-05 04:39:25+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.29-1debian10 started.
2022-07-05 04:39:25+00:00 [Note] [Entrypoint]: Initializing database files
2022-07-05T04:39:25.236592Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.29) initializing of server in progress as process 41
2022-07-05T04:39:25.242037Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2022-07-05T04:39:26.495836Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2022-07-05T04:39:27.394833Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
```

### connecting to Db 

```
[root@docker-server ~]# docker  exec -it ashudb1  bash 
root@d4dce6149ed6:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases; 
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)

```





