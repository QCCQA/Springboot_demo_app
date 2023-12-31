# Docker Build Maven Stage
FROM maven:3.8.3-openjdk-17 AS build
# Copy folder in docker
# WORKDIR /opt/app
COPY ./ /opt/app
WORKDIR /opt/app
RUN mvn clean install -DskipTests
# Run spring boot in Docker
FROM openjdk:17-jdk-alpine
COPY --from=build /opt/app/target/*.war app.war
ENV PORT 8081
EXPOSE $PORT
ENTRYPOINT ["java","-jar","-Xmx1024M","-Dserver.port=${PORT}","app.war"]
