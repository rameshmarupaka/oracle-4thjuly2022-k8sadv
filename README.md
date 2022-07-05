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


