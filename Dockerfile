FROM tomcat:9.0.30-jdk8-openjdk-slim

COPY ./target/docker-java-sample-webapp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sample.war
EXPOSE 8080

CMD ["catalina.sh", "run"]