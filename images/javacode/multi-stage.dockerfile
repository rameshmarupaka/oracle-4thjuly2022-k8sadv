from oraclelinux:8.4  as Stage1 
label name=ashutoshh
label email=ashutoshh@linux.com
RUN mkdir /javawebapp 
# RUN is to get shell while building image 
ADD java-springboot  /javawebapp/ 
# ADD is similar to COPY both can copy folder data 
RUN yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 maven -y 
WORKDIR /javawebapp
# changing directory during build time 
# workdir is like cd command in linux/unix 
RUN mvn clean package 
# build java source code into .war file -- target/WebApp.war 
FROM tomcat 
LABEL email=ashutoshh@linux.com
COPY --from=Stage1  /javawebapp/target/WebApp.war /usr/local/tomcat/webapps/ 