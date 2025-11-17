FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/classes ./classes
COPY --from=build /root/.m2/repository /root/.m2/repository
CMD ["java", "-cp", "classes:/root/.m2/repository/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar", "main.Main"]