# CI/CD Pipeline for a Spring Boot Banking Application on AWS

## Terraform • GitHub Actions • Docker • SonarQube • Trivy • Amazon ECR • ECS/Fargate • ALB • CloudWatch

### Project Overview 
This project demonstrates an end-to-end CI/CD pipeline for a Java Spring Boot banking application deployed on AWS.

The pipeline automates the complete delivery workflow:

- Application build
- Unit testing
- Code-quality analysis
- Container image creation
- Container vulnerability scanning
- Image publication to Amazon ECR
- Deployment to Amazon ECS/Fargate
- Post-deployment health verification
  
The AWS infrastructure is provisioned using Terraform, while GitHub Actions manages the CI/CD workflow.

The banking application is used as the workload so that the project can focus primarily on DevOps, cloud infrastructure, security, automation, and deployment practices.

### Architecture
CloudOps Platform Architecture
Architecture Flow

## Architecture Flow

```text
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
```

### Tech Stack

- **Application**: Java 17, Spring Boot 3.5.16
- **Build Tool**: Maven
- **Testing**: JUnit
- **CI/CD**: GitHub Actions
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker
- **Cloud Platform**: AWS
- **Container Registry**: Amazon ECR
- **Container Deployment**: Amazon ECS/Fargate
- **Load Balancing**: Application Load Balancer
- **Code Quality**: SonarQube
- **Container Security**: Trivy
- **Secrets Management**: AWS Systems Manager Parameter Store
- **Monitoring and Logging**: Amazon CloudWatch
- **Database**: MySQL

### CI/CD Pipeline
The GitHub Actions workflow is organized into the following stages:

1. **Build**
Compiles and packages the Spring Boot application using Maven.

2. **Unit Test**
Runs automated application tests.

3. **SonarQube Quality Gate**
Performs static code analysis and validates the configured Quality Gate.

4. **Build Container**
Builds the Docker image for the banking application.

5. **Trivy Security Scan**
Scans the container image for critical vulnerabilities.

6. **Publish to ECR**
Publishes the validated Docker image to Amazon ECR.

7. **Deploy to ECS**
Triggers a new Amazon ECS/Fargate service deployment.

8. **Verify Deployment**
Waits for ECS service stability and validates the application health endpoint through the ALB.

### AWS Deployment
The application infrastructure is provisioned using Terraform.

The AWS environment includes:

- Amazon VPC
- Two public subnets
- Internet Gateway
- Route tables
- Security Groups
- Application Load Balancer
- ALB Target Group
- Amazon ECR
- Amazon ECS/Fargate
- IAM roles and policies
- AWS Systems Manager Parameter Store
- Amazon CloudWatch
- Docker images are stored in Amazon ECR and deployed as an Amazon ECS/Fargate service.

The Application Load Balancer receives HTTP traffic on port 80 and forwards it to the Spring Boot application running on port 8080.

Application health is verified through:
/health
The ECS service uses a health-check grace period so that the Spring Boot application and MySQL database can complete startup before task health is evaluated.

### Code Quality
**SonarQube**
SonarQube is integrated into the GitHub Actions pipeline for automated code-quality analysis.

The pipeline must pass the configured SonarQube Quality Gate before proceeding to later delivery stages.

SonarQube Community Build is hosted on a Terraform-managed Amazon EC2 instance.

### Container Security
**Trivy**
Trivy scans the Docker image for CRITICAL vulnerabilities before the image is published to Amazon ECR.

The scan is configured as a CI/CD security gate. New unapproved critical findings can fail the pipeline and prevent image publication and deployment.

### Monitoring and Logging
Amazon CloudWatch provides the monitoring and logging foundation for the deployed application.

Current monitoring includes:

- ECS application logs
- CPU utilization
- Memory utilization
- ECS task and service visibility
  
Application logs are centralized under the CloudWatch log group:
/ecs/bank-app

## Screenshots

**1. Banking Application Running through AWS ALB**

<img width="1912" height="940" alt="image" src="https://github.com/user-attachments/assets/bfeefd28-9a49-4834-82cb-f3c28c0fbc3f" />

**2. GitHub Actions CI/CD Pipeline**











