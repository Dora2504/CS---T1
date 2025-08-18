# Spring Boot Project with PostgreSQL using Docker and GitHub Actions

This project is a Java Spring Boot application that uses PostgreSQL as the database, running in two separate Docker containers:
- Spring Boot application container
- PostgreSQL database container

It also includes a simple CI pipeline using GitHub Actions for automatic build and tests.

---

## Requirements

- Docker and Docker Compose installed
- Java 17 (to run locally if not using Docker)
- Gradle (optional, as we use the `./gradlew` wrapper)
- GitHub for CI (configured in the repository)

---

## Structure

- `docker-compose.yml`: defines the two containers (app + db)
- `.github/workflows/ci.yml`: CI pipeline for build and tests in GitHub Actions
- Java Spring Boot source code configured for PostgreSQL

---

## How to run locally with Docker

This project runs the Spring Boot application and PostgreSQL database in two separate Docker containers managed by Docker Compose.

1. Make sure Docker and Docker Compose are installed and running.

2. At the project root, run:
   ```bash
   docker-compose up --build

## How to Rebuild and Run the Project After Code Changes (Using Docker Compose)

When you make changes in the code and want to update your running Docker containers, follow these steps:

   ```bash
   1. Compile the project and generate the new `.jar` file
   
   ./gradlew clean build
   
   ### 2. Start the database container (if not already running)
   docker-compose up -d db

### 3. docker-compose up --build
docker-compose up --build

