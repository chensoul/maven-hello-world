FROM maven:3-eclipse-temurin-21-alpine AS build
WORKDIR /build
COPY . .
RUN mvn install -DskipTests

FROM eclipse-temurin:21-jdk-jammy AS final
WORKDIR /app
COPY --from=build /build/target/*.jar .

ENTRYPOINT ["java", "-jar","app.jar"]

EXPOSE 8080
