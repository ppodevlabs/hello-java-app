FROM maven:3.6.2-jdk-8 AS build  
COPY . /app  
WORKDIR /app 
RUN mvn clean package

FROM tomcat:9.0.30-jdk8-openjdk-slim

COPY --from=build /app/target/docker-java-sample-webapp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sample.war
EXPOSE 8080

CMD ["catalina.sh", "run"]