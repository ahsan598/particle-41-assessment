# 🧭 Simple Time Service MicroService App

A minimal **Node.js** microservice that returns the current **Timestamp** and the **Client's IP** address in JSON format.

**API Endpoint Output**
```cpp
{
  "timestamp": "YYYY-MM-DDTHH:MM:SS.000Z",  // Current UTC time in ISO 8601 format
  "ip": "::1"                              // Client's IP address (::1 = IPv6 localhost)
}
```


### ⚙️ Prerequisites

Before starting this project, ensure you have the following tools installed on your machine.  
If any of these tools are not installed, please install them first before proceeding with the project setup.

| Tool        | Purpose                                   | Documentation              |
|-------------|-------------------------------------------|----------------------------|
| **Node.js** | Runtime used to execute the microservice  | Refer this document to install [Node.js](https://nodejs.org/en/download)         |
| **npm**     | Package manager for installing dependencies | Refer this document to know more about [npm](https://docs.npmjs.com/) |
| **Docker**  | Builds and runs the container image for this service | Refer this document to install [Docker](https://docs.docker.com/engine/install/)  |
| **KIND** *(optional)* | To deploy the microservice locally on Kubernetes using Kind | Refer this document to install [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)            |


> **Note:** Node.js includes npm, no need to install separately.
> 
> All Docker commands in this guide are shown without `sudo`.  
> If your system requires root privileges to run Docker, either use `sudo` before every command  
> or add your user to the docker group:
> 
> ```sh
> sudo usermod -aG docker $USER
> newgrp docker
> ```

---

### 📂 Project Structure
```perl
app/                               # Root folder of the project
├── src/                           # Application source code
│   └── index.js                   # Main Node.js application file (API endpoint)
├── package.json                   # Project metadata + dependencies
├── package-lock.json              # Dependency lock file for reproducible installs
├── Dockerfile                     # Multi-stage docker build file to containerize the app
├── .dockerignore                  # Files/folders docker should ignore during image build
├── k8s/                           # Kubernetes manifests for deployment
│   ├── deployment.yaml            # Kubernetes deployment (pods, replicas, probes)
│   └── service.yaml               # Kubernetes service (expose pod in/outside cluster)
├── .gitignore                     # Files git should ignore (node_modules, logs, env)
└── README.md                      # Documentation on how to run, build & deploy the app
```


### 🔧 Implementation Steps
**Step-1: Clone this Project & Run Locally Without Docker**
```sh
# Clone the repository
git clone https://github.com/ahsan598/particle-41-assessment.git

# Move into the project directory
cd particle-41-assessment/app

# Install dependencies
npm install

# Run locally
npm start

# Browse the service at
http://localhost:8080
```

**Step-2: Pull Docker Image & Run Container**
```sh
# Pull image from DockerHub
docker pull ahsan98/sts:1.0

# Verify image got pulled
docker images

# Run the container in detached mode with pulled image
docker run -dp 8080:8080 --name <container-name> ahsan98/sts:1.0

# Verify the container is running
docker ps

# Browse the service at
http://localhost:8080
```

**Step-3: Tag & Push Image to DockerHub (For Publishing Your Build)**
```sh
# Build image
docker build -t <image-name>:<tag> .

# Login to DockerHub
docker login

# Tag the image
docker tag <image-name>:<tag> your-dockerhub-username/<image-name>:<tag>

# Push the Docker image to Docker Hub
docker push <dockerhub-username>/<image-name>:<tag>

# Verify by pulling the same image (recommended)
docker pull <dockerhub-username>/<image-name>:<tag>
docker images
```

**Step-4: Kubernetes Deployment (Optional)**
```sh
# Apply kubernetes manifests
kubectl apply -f k8s/

# Verify that Deployment, Pods, and Service were created
kubectl get all -l app=sts

# Check the Service endpoints (should show Pod IPs)
kubectl get endpoints sts-svc

# Access the service locally (port-forward)
kubectl port-forward svc/sts-svc 8080:80

# Browse the service at
http://localhost:8080
```

**Step-5: Clean up Everything**
```sh
# Stop & remove container
docker rm -f <container-name>

# Remove image
docker rmi <image-name>:<tag>

# Delete all K8s resources for this app
kubectl delete -f k8s/
```


### 📚 Features
- Lightweight Node.js API
- Multi-stage Docker build
- Health probes (liveness/readiness)
- Non-root container user
- Clean and production-friendly structure

---

