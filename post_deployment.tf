provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" # Uses the default kubeconfig path
  }
}

# Null resource to configure kubectl (Update kubeconfig)
resource "null_resource" "configure_kubectl" {
  depends_on = [aws_eks_cluster.eks_cluster]

  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
  }
}

# Ensure Helm is installed
resource "null_resource" "install_helm" {
  provisioner "local-exec" {
    command = <<EOT
    if ! command -v helm &> /dev/null
    then
        echo "Helm not found, installing..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    else
        echo "Helm is already installed."
    fi
    EOT
  }
}

# Helm Release for Prometheus & Grafana deployment
resource "helm_release" "kube_prometheus_stack" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    <<EOF
    grafana:
      adminPassword: "admin123"  # This sets the default password for Grafana
      service:
        type: LoadBalancer  # Change Grafana service to LoadBalancer
    EOF
  ]

  depends_on = [null_resource.configure_kubectl] # Ensure kubectl is configured first
}

# Null resource to retrieve Grafana admin password and LoadBalancer IP
resource "null_resource" "retrieve_grafana_info" {
  depends_on = [helm_release.kube_prometheus_stack]

  provisioner "local-exec" {
    command = <<EOT
    # Get Grafana password
    GRAFANA_PASSWORD=$(kubectl --namespace monitoring get secret prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

    # Get Grafana LoadBalancer URL
    GRAFANA_LB_URL=$(kubectl get svc -n monitoring prometheus-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

    # Output the result as a user-friendly message
    echo "Grafana Admin Password: $GRAFANA_PASSWORD"
    echo "Grafana LoadBalancer URL: http://$GRAFANA_LB_URL"
    EOT
  }
}

# Output Grafana Admin Password and LoadBalancer URL as a nice message
output "grafana_access_info" {
  value       = "Grafana Admin Password and Access URL will be shown above."
  description = "After running terraform apply, the Grafana admin password and LoadBalancer URL will be shown automatically."
}
