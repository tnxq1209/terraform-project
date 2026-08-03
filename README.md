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
- Amazon EKS
- Argo CD
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