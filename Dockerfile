# ==============================
# STAGE 1: BASE - Dependências
# ==============================
FROM gradle:8.5-jdk17 AS base
WORKDIR /app

# Copia arquivos de configuração do Gradle para cache de dependências
COPY build.gradle settings.gradle ./
COPY gradlew ./
COPY gradle ./gradle

# Baixa dependências (será cacheado)
RUN ./gradlew build --no-daemon -x test || return 0

# ==============================
# STAGE 2: BUILDER - Build do JAR
# ==============================
FROM base AS builder
WORKDIR /app

# Copia código fonte
COPY src ./src

# Build do shadowJar (ignora testes)
RUN ./gradlew clean shadowJar --no-daemon --stacktrace && \
    echo "Arquivos gerados:" && ls -l /app/build/libs

# ==============================
# STAGE 3: PRODUCTION - Lambda
# ==============================
FROM public.ecr.aws/lambda/java:17 AS production

# Copia apenas o JAR gerado pelo builder
COPY --from=builder /app/build/libs/demo-0.0.1-SNAPSHOT-all.jar ${LAMBDA_TASK_ROOT}/app.jar

# Define handler correto (atenção ao package da sua classe)
CMD ["com.construcaosoftware.demo.lambda.StreamLambdaHandler::handleRequest"]

