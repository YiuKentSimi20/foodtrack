# --- STAGE 1: Builder ---
FROM eclipse-temurin:25-jdk-alpine AS builder

WORKDIR /build

# Instalam Maven (imaginea de baza contine doar Java)
RUN apk add --no-cache maven

# Copiem pom.xml și descarcam dependentele (Cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiem codul sursa
COPY src ./src

# Compilam aplicatia
RUN mvn clean package -DskipTests


# --- STAGE 2: Runtime ---
# FOLOSIM JAVA 25 si JRE (pentru ca aplicatia e deja compilata)
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Copiem JAR-ul generat din stadiul 'builder'
# (Folosim wildcard *.jar in caz ca versiunea din pom.xml se schimba)
COPY --from=builder /build/target/*.jar app.jar

# Expunem portul (asa cum l-ai setat tu)
EXPOSE 8083

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD java -cp app.jar org.springframework.boot.loader.JarLauncher || exit 1

# Rulam aplicatia
ENTRYPOINT ["java", "-jar", "app.jar"]