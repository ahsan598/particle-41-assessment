# 🚀 Containerized Application Deployment (Docker, Kubernetes, Terraform, AWS)

This repository demonstrates a **minimalist containerized application** and its **cloud-ready infrastructure**.

It is split into two parts:
- **Task 1:** Application containerization using Docker (and optional Kubernetes)
- **Task 2:** Infrastructure provisioning on AWS using Terraform to host the container

This setup is designed to be **simple, repeatable, and production-aligned**.

---

### 📌 Project Purpose

- Build and containerize a lightweight application
- Run the application locally using Docker / Kubernetes
- Provision cloud infrastructure using Terraform
- Deploy the container to AWS ECS (Fargate) behind an ALB
- Serve as a reference project for real-world DevOps workflows


### 📁 Repository Structure

```text
particle-41-assessment/
├── app/                     # Application source code
│     ├── Dockerfile         # Container definition
│     ├── k8s/               # Kubernetes manifests (optional/local)
├── terraform/
│     ├── modules/           # AWS infrastructure (ECS, ALB, VPC, SG)
└── README.md
```


### 📌 Getting Started

Follow the steps below based on the task you want to run:

**Task 1: Application (Docker / Kubernetes)**
```text
1. Navigate to the application directory:
   cd app

2. Follow the instructions provided in:
   app/README.md
```

**Task 2: Infrastructure (Terraform / Cloud)**
```text
1. Navigate to the terraform directory:
   cd terraform

2. Follow the instructions provided in:
   terraform/README.md
```


### ✅ Summary
- **Task 1:** Build & containerize application
- **Task 2:** Deploy container to AWS using Terraform
- **Result:** Publicly accessible application via ALB