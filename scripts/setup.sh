#!/usr/bin/env bash
set -euo pipefail

echo "Setting up InfraCore development environment..."

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "terraform is required but not installed."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl is required but not installed."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "aws CLI is required but not installed."; exit 1; }

echo "All prerequisites found."

# Configure kubectl for staging cluster
aws eks update-kubeconfig --name axiom-staging --region us-east-1

echo "kubectl configured for axiom-staging."
echo "Run 'kubectl get pods -n axiom' to verify connectivity."
