# Docker Cheatsheet for Java Development

## Essential Commands

### Image Management
```bash
# Build image with tag
docker build -t myapp:latest .
docker build -t myapp:1.0.0 --build-arg JAR_FILE=target/myapp-1.0.0.jar .

# List images
docker images
docker image ls

# Remove images
docker rmi myapp:latest
docker image prune -a  # Remove all unused images

# Pull/Push images
docker pull openjdk:17-jdk-alpine
docker push myregistry.com/myapp:1.0.0

# Tag images
docker tag myapp:latest myregistry.com/myapp:1.0.0
```

### Container Lifecycle
```bash
# Run containers
docker run -d --name myapp -p 8080:8080 myapp:latest
docker run -it --rm --name debug-container myapp:latest /bin/sh

# Start/Stop/Restart
docker start myapp
docker stop myapp
docker restart myapp

# Remove containers
docker rm myapp
docker container prune  # Remove all stopped containers

# Execute commands in running container
docker exec -it myapp /bin/bash
docker exec myapp ps aux
```

### Debugging & Monitoring
```bash
# View logs
docker logs myapp
docker logs -f myapp  # Follow logs
docker logs --tail 100 myapp

# Inspect containers
docker inspect myapp
docker stats myapp
docker top myapp

# Copy files to/from container
docker cp myapp:/app/logs/app.log ./logs/
docker cp ./config.properties myapp:/app/config/
```

## Java-Specific Dockerfile Patterns

### Multi-stage Build for Spring Boot
```dockerfile
# Build stage
FROM maven:3.8.6-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-alpine
WORKDIR /app
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
COPY --from=build /app/target/*.jar app.jar
RUN chown appuser:appuser app.jar
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Gradle Build
```dockerfile
FROM gradle:7.6-jdk17-alpine AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
RUN gradle dependencies --no-daemon
COPY src ./src
RUN gradle bootJar --no-daemon

FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### JVM Optimization
```dockerfile
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY app.jar .
# JVM tuning for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport \
               -XX:MaxRAMPercentage=75.0 \
               -XX:+UseG1GC \
               -XX:+UseStringDeduplication \
               -Djava.security.egd=file:/dev/./urandom"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

## Docker Compose for Development

### Basic Spring Boot Stack
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/myapp
    depends_on:
      - db
      - redis
    volumes:
      - ./logs:/app/logs

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### Microservices with Service Discovery
```yaml
version: '3.8'
services:
  eureka:
    image: steeltoeoss/eureka-server
    ports:
      - "8761:8761"

  config-server:
    build: ./config-server
    ports:
      - "8888:8888"
    depends_on:
      - eureka

  user-service:
    build: ./user-service
    ports:
      - "8081:8080"
    environment:
      - EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://eureka:8761/eureka
    depends_on:
      - eureka
      - db

  gateway:
    build: ./api-gateway
    ports:
      - "8080:8080"
    depends_on:
      - eureka
      - user-service
```

## Networking & Volumes

### Custom Networks
```bash
# Create network
docker network create myapp-network

# Run containers on same network
docker run -d --name db --network myapp-network postgres:15
docker run -d --name app --network myapp-network -p 8080:8080 myapp:latest

# List networks
docker network ls
```

### Volume Management
```bash
# Create named volume
docker volume create myapp-data

# Mount volumes
docker run -v myapp-data:/app/data myapp:latest
docker run -v $(pwd)/logs:/app/logs myapp:latest  # Bind mount

# List and inspect volumes
docker volume ls
docker volume inspect myapp-data
```

## Production Considerations

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1
```

### Security Best Practices
```dockerfile
# Use non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
USER appuser

# Use specific base image versions
FROM openjdk:17.0.2-jdk-alpine3.15

# Minimize attack surface
RUN apk add --no-cache curl && \
    rm -rf /var/cache/apk/*
```

### Resource Limits
```bash
# Limit memory and CPU
docker run -m 512m --cpus="1.0" myapp:latest

# In docker-compose
services:
  app:
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

## Useful Debugging Commands

### Performance Analysis
```bash
# Container resource usage
docker stats --no-stream

# Process monitoring inside container
docker exec myapp top
docker exec myapp ps aux

# JVM debugging
docker exec myapp jps -l
docker exec myapp jstack <PID>
docker exec myapp jmap -histo <PID>
```

### Log Analysis
```bash
# Filter logs by timestamp
docker logs --since="2023-01-01T00:00:00" myapp
docker logs --until="2023-01-01T23:59:59" myapp

# Search logs
docker logs myapp 2>&1 | grep "ERROR"
docker logs myapp 2>&1 | grep -i "exception"
```

### Environment Inspection
```bash
# Check environment variables
docker exec myapp env

# Check Java system properties
docker exec myapp java -XshowSettings:properties -version

# File system inspection
docker exec myapp ls -la /app
docker exec myapp df -h
```

## Registry & Deployment

### Docker Registry Operations
```bash
# Login to registry
docker login myregistry.com

# Build and push
docker build -t myregistry.com/myapp:1.0.0 .
docker push myregistry.com/myapp:1.0.0

# Multi-platform builds
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest --push .
```

### Container Orchestration Prep
```bash
# Export/Import images
docker save myapp:latest | gzip > myapp.tar.gz
docker load < myapp.tar.gz

# Create deployment-ready compose
docker-compose config > docker-compose.prod.yml
```

## Cleanup Commands

```bash
# Complete cleanup
docker system prune -a --volumes

# Selective cleanup
docker image prune -a  # Remove unused images
docker container prune  # Remove stopped containers
docker volume prune    # Remove unused volumes
docker network prune   # Remove unused networks

# Remove everything related to project
docker-compose down --volumes --remove-orphans
docker rmi $(docker images "myapp*" -q)
```

## Environment Variables & Secrets

### Spring Boot Configuration
```bash
# Runtime configuration
docker run -e SPRING_PROFILES_ACTIVE=prod \
           -e SPRING_DATASOURCE_URL=jdbc:postgresql://prod-db:5432/app \
           -e SPRING_DATASOURCE_PASSWORD_FILE=/run/secrets/db_password \
           myapp:latest

# Using .env file with docker-compose
echo "SPRING_PROFILES_ACTIVE=development" > .env
docker-compose up
```

### Secrets Management
```yaml
# docker-compose with secrets
services:
  app:
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```