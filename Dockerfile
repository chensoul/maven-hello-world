FROM maven:3.9.6-openjdk-17-slim AS build
WORKDIR /build
COPY . .
RUN mvn clean install

FROM eclipse-temurin:21-jdk-jammy AS base
WORKDIR /app
COPY --from=build /build/target/*.jar .

ENTRYPOINT ["java", "-jar","app.jar"]

EXPOSE 8080
