# JFrog Supply-Chain Demo App

Small demo repository for showing a basic software supply-chain flow with:

- `frontend/`: Node.js npm app
- `backend/`: Java Maven app
- `Dockerfile`: final container image
- `.github/workflows/jfrog-ci.yml`: GitHub Actions pipeline using `jfrog/setup-jfrog-cli@v4`

The CI pipeline demonstrates npm build, Maven build, Docker build, Docker push to Artifactory, JFrog build-info publication, and Xray build scanning.

## Repository Layout

```text
frontend/
  package.json
  src/index.js
backend/
  pom.xml
  src/main/java/com/example/demo/App.java
Dockerfile
.github/workflows/jfrog-ci.yml
demo-fake-secrets.txt
```

## GitHub Secrets

Create these GitHub repository secrets before running the workflow:

- `ARTIFACTORY_URL`: JFrog Platform URL, for example `https://acme.jfrog.io`
- `ARTIFACTORY_USERNAME`: demo or service account username
- `ARTIFACTORY_PASSWORD`: demo password or access token
- `DOCKER_REGISTRY`: Docker registry host, for example `acme.jfrog.io`
- `REPO_PREFIX`: Docker repository path or prefix, for example `docker-local` or `team-demo/docker-local`

Do not commit real credentials. `demo-fake-secrets.txt` contains fake values only for demo setup notes.

## Local Demo

Build the frontend:

```bash
cd frontend
npm install
npm run build
```

Build the backend:

```bash
cd backend
mvn clean package
```

Build the Docker image from the repository root:

```bash
docker build -t jfrog-supply-chain-demo:local .
```

Run the container:

```bash
docker run --rm jfrog-supply-chain-demo:local
```

## CI Flow

The GitHub Actions workflow:

1. Checks out the repository.
2. Installs Node.js and Java.
3. Sets up JFrog CLI with `jfrog/setup-jfrog-cli@v4`.
4. Runs `npm ci` and `npm run build` in `frontend/`.
5. Runs `mvn clean package` in `backend/`.
6. Builds the Docker image.
7. Logs in to Artifactory Docker registry.
8. Pushes the Docker image with JFrog CLI build-info collection.
9. Publishes JFrog build info.
10. Runs an Xray build scan.

The workflow intentionally uses the official JFrog setup action, avoids real secrets, and lets failures fail the job normally.
