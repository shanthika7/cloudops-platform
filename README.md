**CI/CD Pipeline for Spring Boot Application using GitHub Actions, Docker & AWS ECS**

**Project Overview**
This project demonstrates an end-to-end CI/CD pipeline for a Java Spring Boot banking application deployed on AWS.

The project focuses on DevOps practices by automating application build, testing, code-quality analysis, container security scanning, containerization, image publishing, deployment, and health verification.

Infrastructure is provisioned using Terraform, while GitHub Actions manages the CI/CD workflow.

**Architecture Flow**
Developer
   ↓
GitHub Repository
   ↓
GitHub Actions
   ↓
Maven Build
   ↓
Unit Tests
   ↓
SonarQube Quality Gate
   ↓
Docker Image Build
   ↓
Trivy Security Scan
   ↓
Amazon ECR
   ↓
Amazon ECS / Fargate
   ↓
Application Load Balancer
   ↓
Spring Boot Banking Application

**AWS Application Flow**
User / Browser
      ↓
Application Load Balancer :80
      ↓
Target Group /health
      ↓
Amazon ECS / Fargate :8080
      ↓
Spring Boot Banking Application
      ↓
MySQL

**Tech Stack**
  Application: Java 17, Spring Boot
  Build Tool: Maven
  CI/CD: GitHub Actions
  Infrastructure as Code: Terraform
  Containerization: Docker
  Cloud: AWS
  Container Registry: Amazon ECR
  Container Platform: Amazon ECS / Fargate
  Load Balancer: Application Load Balancer
  Code Quality: SonarQube
  Security Scanning: Trivy
  Secrets Management: AWS Systems Manager Parameter Store
  Monitoring: Amazon CloudWatch
  Database: MySQL

**  CI/CD Pipeline**
The GitHub Actions pipeline is divided into the following stages:

Build – Compile and package the Spring Boot application using Maven
Unit Test – Execute automated application tests
SonarQube Quality Gate – Perform static code analysis and enforce the Quality Gate
Build Container – Build the Docker image
Trivy Security Scan – Scan the container image for critical vulnerabilities
Publish to ECR – Push the validated image to Amazon ECR
Deploy to ECS – Trigger a new Amazon ECS/Fargate deployment
Verify Deployment – Wait for ECS stability and verify application health through the ALB

**AWS Deployment**
The application infrastructure is provisioned using Terraform.

The AWS environment includes:

Amazon VPC
Two public subnets
Internet Gateway
Route tables
Security Groups
Application Load Balancer
ALB Target Group
Amazon ECR
Amazon ECS/Fargate
IAM roles
AWS Systems Manager Parameter Store
Amazon CloudWatch
Docker images are stored in Amazon ECR and deployed as an Amazon ECS/Fargate service.

The Application Load Balancer routes incoming traffic to the Spring Boot application running on port 8080.

Application health is verified using:

/health


**Code Quality & Security**
SonarQube
SonarQube is integrated into the GitHub Actions pipeline for automated code-quality analysis.

The SonarQube Quality Gate must pass before the pipeline proceeds to container publication and deployment.

Trivy
Trivy scans the Docker image for CRITICAL vulnerabilities before the image is published to Amazon ECR.

The security scan acts as a CI/CD gate, allowing approved exceptions while continuing to fail the pipeline for new unapproved critical findings.

**Monitoring**
Amazon CloudWatch is used for application logging and ECS monitoring.

Current monitoring includes:

Application logs
ECS CPU utilization
ECS memory utilization
Application logs are available through the CloudWatch log group:

/ecs/bank-app

**Project Status**
Core CI/CD and AWS ECS deployment workflow is implemented and operational.

