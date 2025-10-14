# --- ESTÁGIO 1: O Construtor (Builder) ---
# Usamos uma imagem oficial do Gradle que já contém o JDK (Java Development Kit)
# para compilar nossa aplicação.
# A tag "AS builder" dá um nome a este estágio.
FROM gradle:8.5-jdk17-alpine AS builder

# Define o diretório de trabalho dentro do contêiner do builder
WORKDIR /app

# Copia apenas os arquivos de manifesto do Gradle.
# O Docker armazena essa camada em cache. Se os arquivos não mudarem,
# o Docker reutiliza o cache em vez de baixar as dependências novamente.
COPY build.gradle settings.gradle ./
# Se você não usa Kotlin DSL, copie os arquivos .gradle:
# COPY build.gradle settings.gradle ./

# Copia o wrapper do gradle, se você o utilizar no projeto
COPY gradlew ./
COPY gradle ./gradle

# Baixa e instala as dependências da aplicação.
RUN gradle build --no-daemon || return 0

# Agora copia todo o código-fonte do seu projeto
COPY src ./src

# O comando principal: Compila o projeto e cria o .jar executável.
# O `-x test` pula a execução dos testes, tornando o build mais rápido.
# Para um ambiente de CI/CD, você pode querer rodar os testes.
RUN gradle bootJar --no-daemon --stacktrace

# --- ESTÁGIO 2: A Imagem Final de Execução ---
# Começamos de uma base nova e limpa. A imagem 'jre-slim' é otimizada
# e contém apenas o Java Runtime Environment (JRE), que é o necessário para rodar,
# tornando a imagem final muito menor e mais segura.
FROM openjdk:17-jdk-slim

# Define o diretório de trabalho na imagem final
WORKDIR /app

# Copia APENAS o artefato .jar gerado no estágio 'builder'.
# Este é o pulo do gato do multi-stage build.
COPY --from=builder /app/build/libs/*.jar app.jar

# Expõe a porta em que a aplicação Spring Boot vai rodar (o padrão é 8080).
# Este é um ato de documentação; a porta precisa ser mapeada no 'docker run'.
EXPOSE 8080

# O comando que será executado quando o contêiner iniciar.
# Ele simplesmente executa o .jar.
ENTRYPOINT ["java", "-jar", "app.jar"]