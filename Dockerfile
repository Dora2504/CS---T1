# --- ESTÁGIO 1: Builder ---
FROM gradle:8.5-jdk17 AS builder
WORKDIR /app

# Copia arquivos de build para cache
COPY build.gradle settings.gradle ./
COPY gradlew ./
COPY gradle ./gradle

# Copia código-fonte
COPY src ./src

# Compila e gera o bootJar
# Compila e gera o bootJar **com debug**
RUN ./gradlew clean shadowJar --no-daemon --stacktrace && \
    echo "Arquivos gerados:" && ls -l /app/build/libs


# --- ESTÁGIO 2: Imagem Lambda ---
FROM public.ecr.aws/lambda/java:17

# Copia o JAR gerado para a imagem Lambda
COPY --from=builder /app/build/libs/demo-0.0.1-SNAPSHOT-all.jar ${LAMBDA_TASK_ROOT}/app.jar

# Define o handler para o Lambda
# Para Spring Boot Lambda com adapter: com.meuapp.StreamLambdaHandler::handleRequest
CMD ["com.meuapp.StreamLambdaHandler::handleRequest"]

