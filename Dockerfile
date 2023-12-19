FROM tomcat
COPY ./target/*.war /usr/local/tomcat/webapps/
EXPOSE 8080
