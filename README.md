# Production-Ready AWS VPC using Terraform

A reusable and modular Terraform project that provisions a production-style AWS Virtual Private Cloud (VPC) following AWS networking best practices.

This project was built as part of my DevOps learning journey to understand Terraform fundamentals, reusable modules, and AWS networking concepts from scratch.

---

## Architecture

```
                                Internet
                                    │
                            Internet Gateway
                                    │
                           Public Route Table
                          0.0.0.0/0 → IGW
                           ▲                ▲
                           │                │
                    Public Subnet 1   Public Subnet 2
                     (us-east-1a)      (us-east-1b)
                           │                │
                    Elastic IP        Elastic IP
                           │                │
                    NAT Gateway 1    NAT Gateway 2
                           │                │
                  Private RT 1      Private RT 2
                           ▲                ▲
                           │                │
                   Private Subnet 1 Private Subnet 2
                    (us-east-1a)     (us-east-1b)
```

---

## Features

- Modular Terraform architecture
- Reusable VPC module
- Custom VPC
- Multi-AZ deployment
- Two Public Subnets
- Two Private Subnets
- Internet Gateway
- One shared Public Route Table
- Private Route Table per Availability Zone
- Elastic IPs
- NAT Gateway per Availability Zone
- Route Table Associations
- Dynamic resource creation using `for_each`
- Common resource tagging
- Remote state compatible
- Production-oriented folder structure

---

## Project Structure

```text
terraform/
│
├── provider.tf
├── backend.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── main.tf
│
└── modules/
    └── vpc/
        ├── main.tf
        ├── subnets.tf
        ├── internet_gateway.tf
        ├── route_tables.tf
        ├── nat_gateway.tf
        ├── variables.tf
        ├── locals.tf
        └── outputs.tf
```

---

## AWS Resources Created

- VPC
- Public Subnets (2)
- Private Subnets (2)
- Internet Gateway
- Public Route Table
- Private Route Tables (2)
- Route Table Associations
- Elastic IPs (2)
- NAT Gateways (2)

---

## Terraform Concepts Used

### Core Concepts

- Providers
- Resources
- Variables
- Outputs
- Locals
- Modules

### Advanced Concepts

- `for_each`
- Map of Objects
- Object Variables
- Dynamic Resource Creation
- Resource Dependencies
- Filtering using `for` expressions
- Resource Referencing
- Remote Backend Ready

---

## Example Input

```hcl
vpc_cidr = "10.0.0.0/16"

public_subnets = {

  public-1 = {
    cidr = "10.0.1.0/24"
    az   = "us-east-1a"
  }

  public-2 = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
  }

}

private_subnets = {

  private-1 = {
    cidr        = "10.0.11.0/24"
    az          = "us-east-1a"
    nat_gateway = "public-1"
  }

  private-2 = {
    cidr        = "10.0.12.0/24"
    az          = "us-east-1b"
    nat_gateway = "public-2"
  }

}
```

---

## Learning Outcomes

While building this project, I learned:

- AWS networking fundamentals
- VPC architecture
- Public vs Private subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Route Table Associations
- High Availability networking design
- Modular Terraform design
- Data-driven infrastructure
- Reusable infrastructure modules
- Infrastructure as Code (IaC) best practices

---

## EKS Infrastructure

After building the VPC, I extended the same Terraform project to provision an Amazon EKS cluster on top of the existing networking foundation.

The EKS setup was built manually with Terraform to understand the AWS resources behind EKS rather than using a higher-level tool such as `eksctl`.

### EKS Architecture

```text
                         AWS
                          │
                    ┌─────┴─────┐
                    │    VPC    │
                    │10.0.0.0/16│
                    └─────┬─────┘
                          │
             ┌────────────┴────────────┐
             │                         │
       Public Subnets             Private Subnets
       10.0.1.0/24                10.0.11.0/24
       10.0.2.0/24                10.0.12.0/24
             │                         │
       Internet-facing             EKS Worker Nodes
       infrastructure               (t3.small)
                                         │
                              ┌──────────┴──────────┐
                              │                     │
                           Node 1                Node 2
                              │                     │
                              └──────────┬──────────┘
                                         │
                                    Kubernetes
                                      Pods
```

The worker nodes are placed in the existing private subnets. Public subnets remain available for future internet-facing infrastructure such as an Application Load Balancer.

### EKS Module Structure

```text
modules/
├── eks/
│   ├── eks.tf
│   ├── variables.tf
│   └── output.tf
│
├── iam/
│   ├── iam.tf
│   ├── ekspolicy.tf
│   ├── variables.tf
│   └── output.tf
│
└── vpc/
    ├── association.tf
    ├── eip.tf
    ├── internet_gateway.tf
    ├── nat_gateway.tf
    ├── output.tf
    ├── route_tables.tf
    ├── subnets.tf
    ├── variables.tf
    └── vpc.tf
```

### EKS Cluster

The EKS cluster was created with Terraform using the existing VPC and private subnets.

```hcl
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
```

The cluster control plane is AWS-managed. The subnet IDs configure networking for the EKS control plane; the Kubernetes worker nodes are separate EC2 instances created through the managed node group.

### Managed Node Group

```hcl
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "devboard-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}
```

The final node group configuration uses two desired `t3.small` On-Demand nodes, with scaling from 1 to 3 nodes, in the private subnets.

### IAM Roles

Separate IAM roles were created for the EKS components.

#### EKS Cluster Role

The EKS control plane uses an IAM role trusted by the EKS service:

```text
eks-cluster-role
        │
        └── AmazonEKSClusterPolicy
```

#### EKS Node Role

The worker nodes use a separate EC2-trusted IAM role:

```text
eks-node-role
        │
        ├── AmazonEKSWorkerNodePolicy
        ├── AmazonEC2ContainerRegistryPullOnly
        └── AmazonEKS_CNI_Policy
```

These policies provide the basic permissions required for worker nodes to operate with EKS, pull container images from ECR, and use AWS VPC CNI networking.

### EKS Add-ons

The cluster was configured with the standard EKS add-ons:

```hcl
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"
  depends_on   = [aws_eks_node_group.main]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
}
```

- **VPC CNI** — Kubernetes Pod networking through the AWS VPC networking model.
- **CoreDNS** — DNS-based service discovery inside the Kubernetes cluster.
- **kube-proxy** — Kubernetes Service networking.

### EKS OIDC and IRSA

The EKS cluster exposes an OIDC issuer, and Terraform creates an AWS IAM OIDC provider from it. This enables **IAM Roles for Service Accounts (IRSA)**, allowing Kubernetes service accounts to assume IAM roles using web identity tokens.

```text
EKS Cluster
     │
     └── OIDC Issuer
             │
             ▼
     IAM OIDC Provider
             │
             ▼
     STS AssumeRoleWithWebIdentity
```

The OIDC provider was configured with `sts.amazonaws.com` as its client ID.

### EBS CSI Driver and IAM

The EBS CSI driver was added because the eventual application will contain PostgreSQL with persistent storage.

```text
PostgreSQL
    │
    ▼
PersistentVolumeClaim
    │
    ▼
EBS CSI Driver
    │
    ▼
AWS EBS Volume
```

The EBS CSI add-on uses the IAM role `eks-ebs-csi-role`, which trusts the Kubernetes service account:

```text
system:serviceaccount:kube-system:ebs-csi-controller-sa
```

The role is attached to the available AWS-managed policy:

```text
AmazonEBSCSIDriverPolicy
```

### EBS CSI / IRSA Debugging

During deployment, the EBS CSI controller initially entered `CrashLoopBackOff` and the EKS add-on became `DEGRADED`.

The controller logs showed:

```text
STS: AssumeRoleWithWebIdentity
403 AccessDenied
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

The IAM trust policy was found to be using the OIDC issuer with `https://` in the condition-key prefix. The condition keys were corrected to use the issuer without the scheme:

```text
oidc.eks.ap-south-1.amazonaws.com/id/<OIDC_ID>:aud
oidc.eks.ap-south-1.amazonaws.com/id/<OIDC_ID>:sub
```

The initial Terraform configuration also referenced `AmazonEBSCSIDriverPolicyV2`, but that policy was not available/attachable in the AWS account at the time. It was changed to the available `AmazonEBSCSIDriverPolicy`.

After the fixes, the controller recovered:

```text
ebs-csi-controller   6/6   Running
ebs-csi-node         3/3   Running
```

and the add-on reached:

```text
status: ACTIVE
health: issues: []
```

This debugging process reinforced the IRSA flow:

```text
Kubernetes ServiceAccount
        │
        ▼
OIDC Token
        │
        ▼
AWS STS AssumeRoleWithWebIdentity
        │
        ▼
IAM Role
        │
        ▼
AWS Permissions
```

### EKS Outputs

The EKS module exposes values needed by other Terraform resources and future infrastructure:

```hcl
output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "oidc_issuer" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
```

### EKS Verification Commands

Check cluster status:

```bash
aws eks describe-cluster \
  --name devboard-eks \
  --region ap-south-1 \
  --query 'cluster.status'
```

Configure `kubectl`:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name devboard-eks
```

Check worker nodes and workloads:

```bash
kubectl get nodes
kubectl get pods -A
```

List EKS add-ons:

```bash
aws eks list-addons \
  --cluster-name devboard-eks \
  --region ap-south-1
```

Check the EBS CSI add-on:

```bash
aws eks describe-addon \
  --cluster-name devboard-eks \
  --addon-name aws-ebs-csi-driver \
  --region ap-south-1
```

### EKS Learning Outcomes

While extending the VPC into an EKS environment, I learned:

- EKS control plane vs worker nodes
- EKS managed node groups
- Running worker nodes in private subnets
- EKS IAM roles and AWS managed policies
- EKS add-ons
- VPC CNI, CoreDNS, and kube-proxy
- EBS CSI driver and persistent storage integration
- EKS OIDC provider
- IAM Roles for Service Accounts (IRSA)
- Kubernetes service accounts and IAM roles
- `AssumeRoleWithWebIdentity`
- Terraform dependency relationships for EKS and IAM
- Debugging EKS add-on failures
- Updating kubeconfig after recreating an EKS cluster
- Verifying EKS resources with AWS CLI and `kubectl`

---

## Future Improvements

- Network ACLs
- Security Group module
- VPC Endpoints
- Flow Logs
- IPv6 support
- Transit Gateway
- AWS Network Firewall
- Route53 Private Hosted Zones
- VPC Peering
- AWS RAM

---

## Next Steps

This VPC module will serve as the networking foundation for the following infrastructure projects:

- EC2 Module
- IAM Roles & Instance Profiles
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Amazon RDS
- Argo CD / GitOps
- GitHub Actions CI/CD
- Monitoring with Prometheus & Grafana

---

## Prerequisites

- Terraform >= 1.5
- AWS CLI
- AWS Credentials Configured
- An AWS Account

---

## Deployment

Initialize Terraform

```bash
terraform init
```

Validate Configuration

```bash
terraform validate
```

Review Execution Plan

```bash
terraform plan
```

Provision Infrastructure

```bash
terraform apply
```

Destroy Infrastructure

```bash
terraform destroy
```

---

## Author

**Tanishq Kumar**

DevOps | Cloud | Terraform | Kubernetes | AWS