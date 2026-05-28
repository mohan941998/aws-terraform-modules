# aws-terraform-modules

Production-grade, reusable Terraform modules for AWS infrastructure. Built from real-world SRE experience managing multi-environment AWS accounts at scale.

## Modules

| Module | Description |
|--------|-------------|
| `modules/vpc` | Multi-AZ VPC with public/private subnets, NAT gateways, flow logs |
| `modules/eks` | EKS cluster with managed node groups, IRSA, cluster addons |
| `modules/rds` | RDS PostgreSQL with multi-AZ, read replicas, automated backups |
| `modules/alb` | Application Load Balancer with SSL termination and WAF |

## Stack
Terraform · AWS · EKS · VPC · RDS · ALB · CloudWatch · IAM

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name             = "prod-vpc"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment          = "prod"
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "prod-cluster"
  cluster_version    = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  environment        = "prod"
}
```

## Getting started

```bash
git clone https://github.com/YOUR_USERNAME/aws-terraform-modules
cd aws-terraform-modules
terraform init
terraform plan -var-file=env/prod.tfvars
terraform apply
```

## Author

**Mohankumar Sekar** — Senior SRE | AWS Certified DevOps Pro
📧 mohandevops1994@gmail.com | [LinkedIn](https://www.linkedin.com/in/mohankumar-sekar-9a2261227)
