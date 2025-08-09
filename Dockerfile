# Imagem base com Java 17
FROM openjdk:17-jdk-slim

# Diretório dentro do container
WORKDIR /app

# Copiar o jar gerado para dentro do container
COPY build/libs/*.jar app.jar

# Expõe a porta padrão do Spring Boot (8080)
EXPOSE 8080

# Comando para rodar o jar
ENTRYPOINT ["java", "-jar", "app.jar"]
