# ============================================================
# EKS Module — Production Kubernetes Cluster
# Author: Mohankumar Sekar | Senior SRE
# ============================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Managed node groups
  eks_managed_node_groups = {
    general = {
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      instance_types = var.instance_types

      labels = {
        role = "general"
      }

      taints = []

      update_config = {
        max_unavailable_percentage = 25
      }
    }
  }

  # OIDC for IAM roles for service accounts (IRSA)
  enable_irsa = true

  # Cluster addons
  cluster_addons = {
    coredns                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true }
    aws-ebs-csi-driver     = { most_recent = true }
  }

  tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "eks"
  })
}

# Node security group — allow internal cluster traffic
resource "aws_security_group_rule" "node_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = module.eks.node_security_group_id
  description       = "Allow nodes to communicate with each other"
}
