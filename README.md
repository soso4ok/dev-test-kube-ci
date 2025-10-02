# NestJS + Redis + Kubernetes CI/CD Showcase

[![CI/CD Pipeline](https://github.com/soso4ok/dev-test-kube-ci/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/soso4ok/dev-test-kube-ci/actions/workflows/ci-cd.yml)

This repository demonstrates a **production-ready CI/CD pipeline** for a NestJS application with Redis, deployed to Kubernetes using GitHub Actions. It highlights best practices in containerization, infrastructure as code (IaC), and DevOps automation.

---

## 📌 Project Overview

The application is a simple NestJS service exposing one endpoint:

- `GET /redis` → returns `{"status": true}` if Redis is reachable.

The focus of this repo is the **pipeline and deployment flow**, not the business logic.

---

## 🏗️ Architecture

1. Developer pushes code to GitHub.  
2. GitHub Actions pipeline runs:
   - Test & scan code  
   - Build Docker image & scan for vulnerabilities  
   - Push image to Docker Hub  
   - Deploy manifests to Kubernetes via self-hosted runner  

High-level flow:

```
Developer → GitHub Repo → GitHub Actions → Docker Hub → Kubernetes (Minikube/Docker Desktop)
```

Inside Kubernetes, traffic flows:

```
Ingress → Service → NestJS Pods → Redis Pod
```

---

## ✨ Features

- **Multi-stage Dockerfile** → lightweight production image, runs as non-root user
- **CI/CD with GitHub Actions** → build, scan, and deploy automatically
- **Infrastructure as Code** → full stack described in Kubernetes YAML
- **Security**:
  - Secrets injected from GitHub → never stored in repo
  - `npm audit` 
  - NetworkPolicies for zero-trust traffic
  - Pods run as non-root with least privilege
- **Local Deployment** → works with Minikube or Docker Desktop via self-hosted runner
- **Scalability** → Horizontal Pod Autoscaler (HPA) included

---

## ⚙️ Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) **or** Docker Desktop (with Kubernetes enabled)  
- `kubectl` CLI  
- Docker Hub account (for images)  
- GitHub account (for repo + Actions)  

---

## 🚀 Setup

### 1. Clone Repo
```bash
git clone https://github.com/your-username/dev-test-kube-ci.git
cd dev-test-kube-ci
```

### 2. Start Kubernetes
```bash
minikube start
# or enable Kubernetes in Docker Desktop
```

Install Ingress Controller:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

### 3. Configure GitHub Secrets
Go to **Repo → Settings → Secrets and variables → Actions** and add:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN` (Docker Hub access token, not password)
- `REDIS_PASSWORD`

### 4. Register Self-Hosted Runner
In GitHub repo: **Settings → Actions → Runners → New self-hosted runner**  
Follow steps for your OS, then start it:

```bash
cd actions-runner
./run.sh
```

---

## ⚡ CI/CD Pipeline

Workflow: `.github/workflows/ci-cd.yml`

1. **scan** → runs `npm audit`
2. **build-and-push** → builds multi-stage Dockerfile, scans with Trivy, pushes to Docker Hub
3. **deploy** → runs on your self-hosted runner, applies Kubernetes manifests

---

## ▶️ Running

Trigger pipeline:
```bash
git commit --allow-empty -m "Trigger CI/CD"
git push origin main
```

Check pods:
```bash
kubectl get pods -n nest-redis
```

Expected:
```
nestjs-app-xxxx   1/1 Running
redis-xxxx        1/1 Running
```

Access app:
```bash
curl http://localhost/redis
```

Expected:
```json
{"status":true}
```

---

## 🎯 Summary

You now have:
- NestJS app with Redis
- Fully automated GitHub Actions pipeline
- Secure, reproducible Kubernetes deployment
- Local testing with Minikube or Docker Desktop

This repo for devops test task
```
