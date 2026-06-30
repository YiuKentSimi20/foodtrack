# --- STAGE 1: Builder ---
FROM eclipse-temurin:25-jdk-alpine AS builder

WORKDIR /build

# Instalam Maven
RUN apk add --no-cache maven

# Copiem pom.xml și descarcam dependentele
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiem codul sursa
COPY src ./src

# Compilam aplicatia
RUN mvn clean package -DskipTests


# --- STAGE 2: Runtime ---
# FOLOSIM JAVA 25
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Copiem JAR-ul generat din stadiul 'builder'
COPY --from=builder /build/target/*.jar app.jar

# Expunem portul
EXPOSE 8083

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD java -cp app.jar org.springframework.boot.loader.JarLauncher || exit 1

# Rulam aplicatia
ENTRYPOINT ["java", "-jar", "app.jar"]