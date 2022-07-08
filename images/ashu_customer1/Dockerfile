FROM oraclelinux:8.4
LABEL name=ashutoshh
ENV deploy=webapp 
# default value for variable 
RUN yum install httpd -y ; mkdir -p /common/{app1,app2}
COPY html-sample-app /common/app1/
ADD  project-html-website  /common/app2/
COPY deploy.sh /common/
WORKDIR /common
RUN chmod +x deploy.sh
ENTRYPOINT  ["./deploy.sh"] 
#CMD ["./deploy.sh"]
# CMD is to define default process for container 

