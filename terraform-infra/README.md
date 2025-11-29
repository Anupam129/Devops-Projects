## 🏗 Terraform – Infrastructure Provisioning

This folder contains Terraform code used to provision the core infrastructure required for the DevOps project.

### 🌐 What This Terraform Code Creates

- VPC with public and private subnets
- Internet Gateway and route tables
- Security groups for:
  - SSH access
  - HTTP/HTTPS access for the application
- EC2 instance(s) for:
  - Application / Ansible target node
  - Monitoring stack (Prometheus + Grafana)
- (Optional) S3 bucket for logs or state files
- (Optional) EKS cluster for Kubernetes-based deployment
