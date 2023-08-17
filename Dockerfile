# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-8-alpine as base
# FROM maven:3.9.3-amazoncorretto-17 as base
WORKDIR /app
COPY app/ .
RUN mvn wrapper:wrapper
RUN mvn clean install
# RUN ./mvnw dependency:resolve

FROM base as development
ARG MAVEN_CONFIG=
CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN ./mvnw package

FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8080
COPY --from=build /app/target/spring-petclinic-*.jar /spring-petclinic.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-petclinic.jar"]