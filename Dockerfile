FROM maven:3-eclipse-temurin-21-alpine AS build
WORKDIR /build
COPY . .
RUN sed -i -E '159a <mirror>\n<id>aliyun</id>\n<name>Aliyun Mirror</name>\n<url>http://maven.aliyun.com/nexus/content/groups/public/</url>\n<mirrorOf>central</mirrorOf>\n</mirror>' /usr/share/maven/conf/settings.xml \
    && mvn -ntp -B -U clean install -DskipTests

FROM eclipse-temurin:21-jdk-jammy AS final
WORKDIR /app
COPY --from=build /build/target/*.jar .

ENTRYPOINT ["java", "-jar","app.jar"]

EXPOSE 8080
