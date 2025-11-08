.PHONY: help build test clean run docker-up docker-down docker-logs install

# Default target
help:
	@echo "Available targets:"
	@echo "  make build       - Build the project using Gradle"
	@echo "  make test        - Run tests"
	@echo "  make clean       - Clean build artifacts"
	@echo "  make run         - Run the application locally"
	@echo "  make install     - Install dependencies"
	@echo "  make docker-up   - Start Docker containers with hot reload"
	@echo "  make docker-down - Stop Docker containers"
	@echo "  make docker-logs - View Docker logs"
	@echo "  make push-ecr    - Build and push Docker image to AWS ECR"

# Build the project
build:
	./gradlew build

# Run tests
test:
	./gradlew test

# Clean build artifacts
clean:
	./gradlew clean

# Run the application
run:
	./gradlew bootRun

# Install dependencies
install:
	./gradlew build --refresh-dependencies

# Start Docker containers
docker-up:
	@if [ ! -f .env ]; then \
		echo "Error: .env file not found. Please copy .env.example to .env and configure it."; \
		exit 1; \
	fi
	docker compose up -d --build

# Stop Docker containers
docker-down:
	docker compose down

# View Docker logs
docker-logs:
	docker compose logs -f

# Push da imagem Docker para o ECR
push-ecr:
	chmod +x ./scripts/push-docker-ecr.sh
	bash "./scripts/push-docker-ecr.sh"




