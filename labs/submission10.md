# Lab 10 — Cloud Computing Fundamentals

> **Goal:** Research and compare artifact registries and serverless computing platforms across major cloud providers (AWS, GCP, Azure).  

## Task 1 — Artifact registries research

### Artifact registry services by cloud provider

| Cloud provider  | Service                                 |
| --------------- | --------------------------------------- |
| AWS             | Amazon Elastic Container Registry (ECR) |
| Google Cloud    | Google Artifact Registry                |
| Microsoft Azure | Azure Container Registry (ACR)          |

### AWS — Amazon Elastic Container Registry (ECR)

Amazon ECR is a managed container image registry that allows developers to store, manage, and deploy Docker and OCI images.

**Supported artifacts**

* Docker images
* OCI images
* Helm charts

**Key features**

* Vulnerability scanning
* IAM-based access control
* Lifecycle policies for automatic cleanup
* Cross-region replication

**Integrations**

* Amazon ECS
* Amazon EKS
* AWS Lambda
* AWS CodeBuild and CodePipeline

**Pricing model**

* Pay for storage (GB per month)
* Pay for data transfer

---

### Google Cloud — Artifact Registry

Google Artifact Registry is a unified service for storing container images and software packages.

**Supported artifacts**

* Docker images
* Maven packages
* npm packages
* Python packages
* Go modules

**Key features**

* Built-in vulnerability scanning
* IAM access control
* Regional repositories
* Support for multiple artifact formats

**Integrations**

* Google Kubernetes Engine (GKE)
* Cloud Build
* Cloud Run
* Cloud Functions

**Pricing model**

* Pay for storage and network usage

---

### Azure — Azure Container Registry (ACR)

Azure Container Registry is a private container registry service for storing Docker images and OCI artifacts.

**Supported artifacts**

* Docker images
* OCI artifacts
* Helm charts

**Key features**

* Role-based access control (RBAC)
* Geo-replication
* Automated builds
* Vulnerability scanning

**Integrations**

* Azure Kubernetes Service (AKS)
* Azure DevOps
* GitHub Actions
* Azure Functions

**Pricing model**

* Tier-based pricing (Basic, Standard, Premium)

---

### Comparison of artifact registries

| Feature                 | AWS ECR | GCP Artifact Registry | Azure ACR |
| ----------------------- | ------- | --------------------- | --------- |
| Container image support | Yes     | Yes                   | Yes       |
| Multiple package types  | Limited | Yes                   | Limited   |
| Vulnerability scanning  | Yes     | Yes                   | Yes       |
| Geo replication         | Yes     | Yes                   | Yes       |
| CI/CD integration       | Yes     | Yes                   | Yes       |

### Analysis

For a multi-cloud strategy, Google Artifact Registry can be a good choice because it supports multiple package formats such as Docker, npm, Maven, and Python. This makes it easier to manage both container images and application dependencies in one place.

However, when working inside a single cloud environment, using the native registry service (ECR or ACR) is usually better because of deeper integration with the provider’s ecosystem.

---

# Task 2 — Serverless computing platform research

### Main serverless platforms

| Cloud provider  | Service                     |
| --------------- | --------------------------- |
| AWS             | AWS Lambda                  |
| Google Cloud    | Cloud Functions / Cloud Run |
| Microsoft Azure | Azure Functions             |

---

### AWS Lambda

AWS Lambda is a serverless compute service that runs code in response to events without managing servers.

**Supported languages**

* Python
* Node.js
* Java
* Go
* C#

**Execution model**

* Event-driven execution
* HTTP requests through API Gateway

**Maximum execution time**

* 15 minutes

**Pricing**

* Pay per invocation and execution time

---

### Google Cloud Functions / Cloud Run

**Cloud Functions**

Cloud Functions are serverless functions triggered by events or HTTP requests.

**Supported languages**

* Python
* Node.js
* Go
* Java
* .NET

**Maximum execution time**

* Up to 60 minutes 

**Cloud Run**

Cloud Run allows running containerized applications in a serverless environment with automatic scaling.

---

### Azure Functions

Azure Functions is a serverless compute platform for running event-driven applications.

**Supported languages**

* C#
* Python
* Java
* JavaScript
* PowerShell

**Execution model**

* Event triggers
* HTTP triggers
* Queue triggers

**Maximum execution time**

* Up to 10 minutes in the consumption plan

---

### Comparison of serverless platforms

| Feature                | AWS Lambda | GCP Cloud Functions / Run | Azure Functions |
| ---------------------- | ---------- | ------------------------- | --------------- |
| Event-driven execution | Yes        | Yes                       | Yes             |
| HTTP triggers          | Yes        | Yes                       | Yes             |
| Container support      | Limited    | Yes (Cloud Run)           | Yes             |
| Max execution time     | 15 min     | Up to 60 min              | 10 min          |
| Automatic scaling      | Yes        | Yes                       | Yes             |

---

### Analysis — best platform for REST API backend

For a REST API backend, Google Cloud Run is a strong option because it supports containerized applications and allows developers to use any programming language or framework. It also provides automatic scaling and simple deployment of web services.

---

### Reflection — advantages and disadvantages of serverless

**Advantages**

* No server management
* Automatic scaling
* Pay only for actual usage
* Faster deployment

**Disadvantages**

* Cold start latency
* Execution time limits
* Vendor lock-in
* Limited control over infrastructure

---

### Sources

* AWS documentation
* Google Cloud documentation
* Microsoft Azure documentation

