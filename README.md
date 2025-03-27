# AWS EKS Observability with Terraform

This project automates the deployment of an Amazon Elastic Kubernetes Service (EKS) cluster integrated with Prometheus and Grafana for comprehensive observability. By leveraging Terraform, you can set up the entire infrastructure with a single command, ensuring a streamlined and efficient deployment process.

## Features

- **Automated Deployment**: Deploy an EKS cluster along with Prometheus and Grafana using Terraform.
- **Immediate Access**: Upon deployment, access Grafana through a LoadBalancer service with credentials provided in the output.
- **Integrated Configuration**: `kubectl` is automatically configured to interact with the newly created EKS cluster.

## Prerequisites

Before proceeding, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

Additionally, configure your AWS credentials:

```bash
aws configure
```

## Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/Rohan-Dighe/aws-eks-observability.git
cd aws-eks-observability
```

### 2. Initialize Terraform

Initialize the Terraform working directory:

```bash
terraform init
```

### 3. Review and Modify Variables

Examine the `terraform.tfvars` file to adjust any variables as needed for your deployment. Key variables include:

- `aws_region`: AWS region for deployment.
- `eks_cluster_name`: Name of the EKS cluster.
- `eks_node_group_name`: Name of the EKS node group.
- `eks_node_instance_type`: EC2 instance type for nodes.
- `eks_node_desired_size`: Desired number of worker nodes.
- `eks_node_min_size`: Minimum number of worker nodes.
- `eks_node_max_size`: Maximum number of worker nodes.

### 4. Deploy the Infrastructure

Execute the following command to create the EKS cluster and deploy Prometheus and Grafana:

```bash
terraform apply
```

Confirm the action when prompted. Terraform will provision the resources, which may take several minutes.

### 5. Access Grafana Dashboard

Upon successful deployment, Terraform will output the external URL for the Grafana dashboard and the admin password. The output will resemble:

```
Apply complete! Resources: X added, Y changed, Z destroyed.

Outputs:

grafana_dashboard_url = http://<EXTERNAL-IP>:3000
grafana_admin_password = <PASSWORD>
```

**Note**: The default Grafana admin username is `admin`. Use the provided password to log in.

### 6. Configure `kubectl`

Terraform automatically configures `kubectl` to interact with the new EKS cluster. You can verify the configuration by listing the nodes:

```bash
kubectl get nodes
```

This command should display the nodes in your EKS cluster.

## Monitoring and Observability

- **Prometheus**: Collects and stores metrics from your Kubernetes cluster.
- **Grafana**: Visualizes the metrics collected by Prometheus. Pre-configured dashboards provide insights into cluster performance and health.

## Cleanup

To dismantle the infrastructure and avoid incurring additional costs, run:

```bash
terraform destroy
```

Confirm the action when prompted. This command will remove all resources created by Terraform.

## Troubleshooting

- **Resource Creation Issues**: If Terraform encounters errors during deployment, review the error messages and adjust configurations as necessary. Ensure all prerequisites are met.
- **Accessing Grafana**: If the Grafana URL is inaccessible, verify that the LoadBalancer service has been provisioned correctly and that security groups allow inbound access on the required ports.
- **`kubectl` Configuration**: If `kubectl` commands fail, ensure that your kubeconfig is correctly set up. You can manually configure it using:

  ```bash
  aws eks --region <AWS_REGION> update-kubeconfig --name <EKS_CLUSTER_NAME>
  ```

## Contributing

Contributions to enhance this project are welcome. Feel free to fork the repository, make modifications, and submit a pull request.


---

By following this guide, you can efficiently deploy an EKS cluster equipped with robust observability tools, facilitating effective monitoring and management of your Kubernetes workloads.

