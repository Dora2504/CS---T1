# ==============================
# STAGE 1: BASE - Dependências
# ==============================
# Cache buster: 2025-11-16-rebuild-with-simphealth
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

# Cache bust: rebuild JAR with SimpleHealthHandler (2025-11-16-12-30)
RUN echo "Rebuilding JAR with SimpleHealthHandler..."

# Copia código fonte
COPY src ./src

# Build do shadowJar (ignora testes)
RUN ./gradlew clean shadowJar --no-daemon --stacktrace && \
    echo "Arquivos gerados:" && ls -l /app/build/libs

# ==============================
# STAGE 3: PRODUCTION - Lambda
# ==============================
FROM public.ecr.aws/lambda/java:17 AS production

# Copia o JAR para o diretório lib do Lambda (será incluído automaticamente no classpath)
COPY --from=builder /app/build/libs/demo-0.0.1-SNAPSHOT-all.jar ${LAMBDA_TASK_ROOT}/lib/

# Define handler (Lambda runtime procurará na pasta lib/)
CMD ["com.construcaosoftware.demo.lambda.SimpleHealthHandler"]

