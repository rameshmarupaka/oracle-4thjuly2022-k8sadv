FROM nginx
 # docker hub is having that image 
LABEL name=ashutoshh 
LABEL email=ashutoshh@linux.com 
# optional field but to share image designer info 
COPY html-sample-app /usr/share/nginx/html/
# copy entire folder data to nginx app location 