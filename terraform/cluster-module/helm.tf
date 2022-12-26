terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}
data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.devtube.name
  resource_group_name = azurerm_resource_group.devtube.name
}
data "azurerm_key_vault_secret" "ssh" {
  name         = "my-ssh"
  key_vault_id = azurerm_key_vault.devtube.id
  depends_on = [
    azurerm_key_vault_secret.devtube_secret_10
  ]
}
data "azurerm_key_vault_secret" "argo_pass" {
  name         = "argo-password"
  key_vault_id = azurerm_key_vault.devtube.id
  depends_on = [
    azurerm_key_vault_secret.devtube_secret_11
  ]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)

  }
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  create_namespace = "true"
  namespace        = "devtube"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.external_secrets_version
}

resource "helm_release" "argocd" {
  name             = "argocd"
  create_namespace = "true"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  depends_on = [
    helm_release.external_secrets
  ]
  set {
    name  = "configs.credentialTemplates.ssh-creds1.sshPrivateKey"
    value = data.azurerm_key_vault_secret.ssh.value
  }
  set {
    name  = "configs.credentialTemplates.ssh-creds2.sshPrivateKey"
    value = data.azurerm_key_vault_secret.ssh.value
  }
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = data.azurerm_key_vault_secret.argo_pass.value
  }
  values = [
    file(var.argocd_values_file_path)
  ]
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}

resource "kubectl_manifest" "app-of-apps" {
  depends_on = [
    helm_release.argocd
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default

  source:
    repoURL: git@github.com:ronsha001/devtube-infrastructure.git
    targetRevision: HEAD
    path: infra-apps
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd

  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true
YAML
}
resource "kubectl_manifest" "devtube-chart" {
  depends_on = [
    kubectl_manifest.app-of-apps
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: devtube
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: git@github.com:ronsha001/devtube-chart.git
    path: devtube
    targetRevision: HEAD

  destination:
    server: https://kubernetes.default.svc
    namespace: devtube

  syncPolicy:
    syncOptions:
    - CreateNamespace=true

    automated:
      selfHeal: true
      prune: true
YAML
}
resource "kubectl_manifest" "app-of-certificates" {
  depends_on = [
    kubectl_manifest.app-of-apps
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-certificates
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default

  source:
    repoURL: git@github.com:ronsha001/devtube-infrastructure.git
    targetRevision: HEAD
    path: certificates
  destination:
    server: https://kubernetes.default.svc
    namespace: devtube

  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true
YAML
}
resource "kubectl_manifest" "app-of-logs" {
  depends_on = [
    kubectl_manifest.devtube-chart
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-logs
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default

  source:
    repoURL: git@github.com:ronsha001/devtube-infrastructure.git
    targetRevision: HEAD
    path: logs
  destination:
    server: https://kubernetes.default.svc
    namespace: logs

  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true

YAML
}
resource "kubectl_manifest" "app-of-monitor" {
  depends_on = [
    kubectl_manifest.app-of-logs
  ]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-monitor
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default

  source:
    repoURL: git@github.com:ronsha001/devtube-infrastructure.git
    targetRevision: HEAD
    path: monitoring
  destination:
    server: https://kubernetes.default.svc
    namespace: monitor

  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true
YAML
}