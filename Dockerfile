FROM node:20-alpine AS frontend-build
WORKDIR /workspace/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/src ./src
RUN npm run build

FROM maven:3.9.9-eclipse-temurin-17 AS backend-build
WORKDIR /workspace/backend
COPY backend/pom.xml ./
COPY backend/src ./src
RUN mvn clean package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-build /workspace/backend/target/jfrog-supply-chain-demo-backend-1.0.0.jar ./app.jar
COPY --from=frontend-build /workspace/frontend/dist ./frontend
CMD ["java", "-jar", "/app/app.jar"]
