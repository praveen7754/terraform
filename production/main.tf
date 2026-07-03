/*
Production Environment - Main Configuration
This file orchestrates the module composition and instantiation.

IMPORTANT: This file should ONLY contain module calls and data sources.
DO NOT place resources directly here. All resources should be in modules.

Module composition order:
1. Base networking (VPC, subnets, route tables)
2. Security (security groups, IAM)
3. Observability (CloudWatch)
4. Container services (ECR, EKS, node groups)
5. Application services (ALB, RDS)
6. DNS (Route 53, ACM)
*/

# Generate secure random password for RDS
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# ============================================================================
# NETWORKING MODULES
# ============================================================================

# VPC Module - Create Virtual Private Cloud
module "vpc" {
  source = "../modules/vpc"

  vpc_name             = "${var.project_name}-vpc"
  cidr_block           = var.vpc_cidr
  environment          = var.environment
  project_name         = var.project_name
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = var.enable_vpc_flow_logs
  flow_logs_retention  = var.flow_logs_retention_days

  tags = var.tags
}

# Subnet Module - Create public and private subnets
module "subnet" {
  source = "../modules/subnet"

  vpc_id             = module.vpc.vpc_id
  availability_zones = var.availability_zones
  environment        = var.environment
  project_name       = var.project_name

  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs : "public-${idx}" => {
      cidr_block = cidr
      az_index   = idx
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidrs : "private-${idx}" => {
      cidr_block = cidr
      az_index   = idx
    }
  }

  tags = var.tags

  depends_on = [module.vpc]
}

# Internet Gateway Module - Create internet gateway
module "internet_gateway" {
  source = "../modules/internet-gateway"

  vpc_id      = module.vpc.vpc_id
  igw_name    = "${var.project_name}-igw"
  environment = var.environment

  tags = var.tags

  depends_on = [module.vpc]
}

# NAT Gateway Module - Create NAT gateways for private subnets
module "nat_gateway" {
  source = "../modules/nat-gateway"

  public_subnet_ids      = module.subnet.public_subnet_ids
  number_of_nat_gateways = min(length(var.availability_zones), length(module.subnet.public_subnet_ids))
  nat_gateway_name       = "${var.project_name}-nat"
  environment            = var.environment

  tags = var.tags

  depends_on = [module.subnet, module.internet_gateway]
}

# Route Table Module - Create and manage route tables
module "route_table" {
  source = "../modules/route-table"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.subnet.public_subnet_ids
  private_subnet_ids    = module.subnet.private_subnet_ids
  internet_gateway_id   = module.internet_gateway.internet_gateway_id
  nat_gateway_ids       = module.nat_gateway.nat_gateway_ids
  environment           = var.environment

  tags = var.tags

  depends_on = [
    module.vpc,
    module.subnet,
    module.internet_gateway,
    module.nat_gateway
  ]
}

# ============================================================================
# SECURITY MODULES
# ============================================================================

# Security Group Module - Create security groups
module "security_group" {
  source = "../modules/security-group"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment

  security_groups = {
    alb = {
      name        = "alb-sg"
      description = "Security group for Application Load Balancer"
      ingress_rules = [
        {
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
          description     = "Allow HTTP from anywhere"
        },
        {
          from_port       = 443
          to_port         = 443
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
          description     = "Allow HTTPS from anywhere"
        }
      ]
      egress_rules = []
    }
    eks_cluster = {
      name        = "eks-cluster-sg"
      description = "Security group for EKS cluster"
      ingress_rules = [
        {
          from_port       = 443
          to_port         = 443
          protocol        = "tcp"
          cidr_blocks     = [var.vpc_cidr]
          security_groups = []
          description     = "Allow HTTPS from VPC"
        }
      ]
      egress_rules = []
    }
    eks_nodes = {
      name        = "eks-nodes-sg"
      description = "Security group for EKS worker nodes"
      ingress_rules = [
        {
          from_port       = 0
          to_port         = 65535
          protocol        = "tcp"
          cidr_blocks     = [var.vpc_cidr]
          security_groups = []
          description     = "Allow all TCP from VPC"
        },
        {
          from_port       = 0
          to_port         = 65535
          protocol        = "udp"
          cidr_blocks     = [var.vpc_cidr]
          security_groups = []
          description     = "Allow all UDP from VPC"
        }
      ]
      egress_rules = []
    }
    rds = {
      name        = "rds-sg"
      description = "Security group for RDS database"
      ingress_rules = [
        {
          from_port       = 5432
          to_port         = 5432
          protocol        = "tcp"
          cidr_blocks     = []
          security_groups = ["eks_nodes"]
          description     = "Allow PostgreSQL from EKS nodes"
        }
      ]
      egress_rules = []
    }
  }

  tags = var.tags

  depends_on = [module.vpc]
}

# IAM Module - Create roles and policies
module "iam" {
  source = "../modules/iam"

  environment = var.environment

  roles = {
    eks_cluster = {
      name        = "${var.project_name}-eks-cluster-role"
      description = "Role for EKS cluster"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }]
      })
    }
    eks_node_group = {
      name        = "${var.project_name}-eks-node-group-role"
      description = "Role for EKS node group"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }]
      })
    }
  }

  policies = {}

  role_policy_attachments = {
    eks_cluster = [
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    ]
    eks_node_group = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ]
  }

  tags = var.tags
}

# ============================================================================
# CONTAINER SERVICES MODULES
# ============================================================================

# ECR Module - Create container registry
module "ecr" {
  source = "../modules/ecr"

  project_name = var.project_name
  environment  = var.environment

  repositories = {
    api_service = {
      name                 = "${var.project_name}-api-service"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
      encryption_type      = "AES256"
      force_delete         = false
      lifecycle_policy = jsonencode({
        rules = [{
          rulePriority = 1
          action = {
            type = "expire"
          }
          selection = {
            tagStatus     = "untagged"
            countType     = "sinceImagePushed"
            countUnit     = "days"
            countNumber   = 30
          }
        }]
      })
    }
  }

  tags = var.tags
}

# EKS Module - Create Kubernetes cluster
module "eks" {
  source = "../modules/eks"

  cluster_name        = var.eks_cluster_name
  cluster_version     = var.kubernetes_version
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.subnet.all_subnet_ids
  security_group_ids  = [module.security_group.security_group_ids["eks_cluster"]]
  cluster_role_arn    = module.iam.role_arns["eks_cluster"]
  enable_logging      = var.enable_cluster_logging
  environment         = var.environment

  tags = var.tags

  depends_on = [
    module.vpc,
    module.subnet,
    module.security_group,
    module.iam
  ]
}

# Node Group Module - Create worker nodes
module "node_group" {
  source = "../modules/node-group"

  cluster_name       = module.eks.cluster_id
  environment        = var.environment
  node_role_arn      = module.iam.role_arns["eks_node_group"]
  subnet_ids         = module.subnet.private_subnet_ids
  security_group_ids = [module.security_group.security_group_ids["eks_nodes"]]

  node_groups = {
    general = {
      desired_size   = var.desired_capacity
      min_size       = var.min_capacity
      max_size       = var.max_capacity
      instance_types = var.node_instance_types
      disk_size      = 100
      capacity_type  = "ON_DEMAND"
      labels = {
        workload = "general"
      }
      taints = []
      tags   = var.tags
    }
  }

  tags = var.tags

  depends_on = [
    module.eks,
    module.iam
  ]
}

# ============================================================================
# APPLICATION SERVICES MODULES
# ============================================================================

# ALB Module - Create Application Load Balancer
module "alb" {
  source = "../modules/alb"

  alb_name           = "${var.project_name}-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_ids = [module.security_group.security_group_ids["alb"]]
  environment        = var.environment

  enable_deletion_protection = var.alb_deletion_protection
  enable_http2               = true
  enable_cross_zone_load_balancing = true

  target_groups = {
    eks_ingress = {
      name        = "eks-ingress"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    }
  }

  tags = var.tags

  depends_on = [module.subnet, module.security_group]
}

# RDS Module - Create relational database
module "rds" {
  source = "../modules/rds"

  db_subnet_group_name = "${var.project_name}-db-subnet-group"
  db_subnet_ids        = module.subnet.private_subnet_ids
  security_group_ids   = [module.security_group.security_group_ids["rds"]]
  environment          = var.environment

  db_instances = {
    postgres = {
      engine                = var.db_engine
      engine_version        = var.db_engine_version
      instance_class        = var.db_instance_class
      allocated_storage     = var.db_allocated_storage
      storage_type          = "gp3"
      storage_encrypted     = true
      multi_az              = true
      db_name               = var.db_name
      username              = var.db_username
      password              = random_password.db_password.result
      backup_retention_days = var.backup_retention_days
      backup_window         = "03:00-04:00"
      maintenance_window    = "mon:04:00-mon:05:00"
      skip_final_snapshot   = false
      deletion_protection   = true
    }
  }

  tags = var.tags

  depends_on = [module.subnet, module.security_group]
}

# ============================================================================
# OBSERVABILITY MODULES
# ============================================================================

# CloudWatch Module - Create monitoring and logging
module "cloudwatch" {
  source = "../modules/cloudwatch"

  environment = var.environment

  log_groups = {
    eks_cluster = {
      name              = "/aws/eks/${var.eks_cluster_name}"
      retention_in_days = 7
      kms_key_id        = null
    }
  }

  alarms = {}

  dashboards = {}

  tags = var.tags
}

# ============================================================================
# DNS AND CERTIFICATE MODULES (Optional)
# ============================================================================

# Route 53 Module - Create DNS records (uncomment if using custom domain)
# module "route53" {
#   source = "../modules/route53"
# 
#   environment = var.environment
# 
#   hosted_zones = var.domain_name != null ? {
#     main = {
#       name       = var.domain_name
#       private_zone = false
#       vpc_id     = null
#       vpc_region = null
#       comment    = "Main domain"
#     }
#   } : {}
# 
#   dns_records = var.domain_name != null ? {
#     alb = {
#       zone_name      = var.domain_name
#       name           = var.domain_name
#       type           = "A"
#       ttl            = null
#       records        = []
#       alias_name     = module.alb.alb_dns_name
#       alias_zone_id  = module.alb.alb_zone_id
#       routing_policy = "simple"
#     }
#   } : {}
# 
#   tags = var.tags
# 
#   depends_on = [module.alb]
# }

# ACM Module - Create SSL/TLS certificates (uncomment if using custom domain)
# module "acm" {
#   source = "../modules/acm"
# 
#   environment    = var.environment
#   hosted_zone_id = var.domain_name != null ? module.route53.hosted_zone_ids["main"] : null
# 
#   certificates = var.certificate_domain != null ? {
#     main = {
#       domain_name = var.certificate_domain
#       subject_alternative_names = [
#         "*.${var.certificate_domain}"
#       ]
#       validation_method = "DNS"
#       tags = var.tags
#     }
#   } : {}
# 
#   tags = var.tags
# 
#   depends_on = var.domain_name != null ? [module.route53] : []
# }
