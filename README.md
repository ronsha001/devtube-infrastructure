
# Welcome to DevTube Infrastructure

## Dependencies
- Azure Kubernetes Service (AKS)

- ArgoCD

- Helm

## Description
DevTube infrastructure includes the following:
- Terraform (will create your entire Azure infrastructure).
- app-of-apps.yaml (will apply to your kubernetes ArgoCD the resources in `infra-apps` directory).
- app-of-logs.yaml (will apply to your kubernetes ArgoCD the resources in `logs` directory).
- app-of-monitor.yaml (will apply to your kubernetes ArgoCD the resources in `monitoring` directory).
- app-of-certificates.yaml (will apply to your kubernetes ArgoCD the resources in `certificates` directory).
This repository is meant to manage the entire infrastructure of DevTube Web Application.

## Terraform
Terraform directory provides 3 modules for Azure infrastructure:
- acr-module (will create Azure Container Registry).
- cluster-module (will create Azure Kubernetes Service cluster).
- vm-module (will create Azure Virtual Machine with Jenkins on it, including public ip address exposed to port 8080).
In `terraform/main.tf` you can modify variables if you need to.
**Note: changing the video itself or its image is  `NOT` possible!**

## Available Scripts
In the project directory, you can run:
### `terraform`
Inside terraform directory, you can run: `terraform apply`, `terraform plan`, `terraform destroy`, etc...
**Note: with each script you are running, you have to provide subscription_id variable. You can do it with 2 possible ways, edit subscription_id variable in `terraform/variables.yaml` file or manually provide it with each script you are running `Example: terraform apply -var subscription_id=<subscription_id>`.**
