# --- ESTÁGIO 1: O Construtor (Builder) ---
FROM gradle:8.5-jdk17-alpine AS builder
WORKDIR /app

# Copia apenas arquivos de build para cache
COPY build.gradle settings.gradle ./
COPY gradlew ./
COPY gradle ./gradle

# Agora copia todo o código-fonte
COPY src ./src

# Compila o projeto e gera o bootJar executável
RUN gradle bootJar --no-daemon --stacktrace

# --- ESTÁGIO 2: Imagem final ---
FROM openjdk:17-jdk-slim
RUN adduser --disabled-password springuser
USER springuser
WORKDIR /app

# Copia apenas o bootJar gerado
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
