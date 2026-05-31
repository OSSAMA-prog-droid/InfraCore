# InfraCore

Infrastructure-as-code repository for Axiom Analytics — a B2B SaaS platform processing 50M+ real-time events per day.

## Stack

- **Cloud:** AWS (EKS, RDS, ElastiCache, S3, IAM, VPC)
- **IaC:** Terraform 1.7
- **Orchestration:** Kubernetes 1.29 (EKS)
- **CI/CD:** GitHub Actions

## Structure

```
terraform/          Terraform modules and environment configs
  modules/          Reusable modules (networking, database, iam, storage, compute)
  environments/     Per-environment root configs (production, staging)
kubernetes/         Kubernetes manifests applied via kubectl
  deployments/      Application deployments
  services/         ClusterIP / LoadBalancer services
  ingress/          Ingress rules
  configmaps/       App configuration
  rbac/             ServiceAccounts and role bindings
  hpa/              HorizontalPodAutoscalers
.github/workflows/  CI/CD pipelines
scripts/            Utility scripts
```

## Prerequisites

- Terraform >= 1.7
- kubectl >= 1.29
- AWS CLI v2 configured
- Access to the `axiom-production` EKS cluster

## Applying changes

```bash
# Terraform
cd terraform/environments/production
terraform init
terraform plan
terraform apply

# Kubernetes
kubectl apply -f kubernetes/ --recursive
```
