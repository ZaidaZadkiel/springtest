# syntax=docker/dockerfile:experimental

FROM maven:3.9-eclipse-temurin-8-alpine as base
# FROM maven:3.9.3-amazoncorretto-17 as base
WORKDIR /app
COPY app .
RUN mvn clean install
# RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

# # RUN mvn wrapper:wrapper

# COPY mvnw .
# COPY .mvn .mvn
# COPY pom.xml .
# COPY src src

# ADD app/pom.xml .
# COPY app/ .
# RUN --mount=type=cache,target=/root/.m2 ./mvnw install -DskipTests

# RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]
# RUN ./mvnw dependency:resolve
# ADD app/ .
# RUN ["mvn", "package"]

FROM base as development
CMD ["/usr/local/bin/mvn-entrypoint.sh", "./mvnw", "spring-boot:run", "-Dspring-boot.run.profiles=mysql", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN ["/usr/local/bin/mvn-entrypoint.sh", "./mvnw", "package", "spring-boot:repackage"]

FROM maven:3.9-eclipse-temurin-8-alpine as production
EXPOSE 8081
COPY --from=build /app/target/spring-boot-app-*.war /spring-boot-app.war
CMD ["java", "-Dspring.profiles.active=default", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/spring-boot-app.war"]
# RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "spring-boot:run"]