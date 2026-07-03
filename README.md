# AWS Infrastructure - Terraform Repository

## Overview

This repository contains a production-ready Terraform configuration for provisioning AWS infrastructure to deploy Kubernetes microservices on Amazon EKS. The infrastructure is designed to be modular, reusable, and follows Terraform and AWS best practices.

## Repository Structure

```
aws-infrastructure/
├── .github/
│   └── workflows/               # CI/CD pipeline definitions
│       └── terraform.yml        # GitHub Actions workflow for Terraform
│
├── modules/                     # Reusable Terraform modules
│   ├── vpc/                     # Virtual Private Cloud configuration
│   ├── subnet/                  # Subnet resources and management
│   ├── internet-gateway/        # Internet gateway resources
│   ├── nat-gateway/             # NAT gateway for private subnets
│   ├── route-table/             # Route table configurations
│   ├── security-group/          # Security group rules and definitions
│   ├── iam/                     # IAM roles, policies, and users
│   ├── ecr/                     # Elastic Container Registry repositories
│   ├── eks/                     # Elastic Kubernetes Service cluster
│   ├── node-group/              # EKS managed node groups
│   ├── alb/                     # Application Load Balancer configuration
│   ├── rds/                     # Relational Database Service instances
│   ├── cloudwatch/              # CloudWatch monitoring and logging
│   ├── route53/                 # Route 53 DNS configuration
│   └── acm/                     # AWS Certificate Manager certificates
│
└── production/                  # Production environment configuration
    ├── backend.tf               # Terraform state backend (S3 + DynamoDB)
    ├── provider.tf              # AWS provider configuration
    ├── versions.tf              # Terraform and provider version constraints
    ├── variables.tf             # Environment-level input variables
    ├── terraform.tfvars         # Environment-specific values
    ├── main.tf                  # Module composition and orchestration
    └── outputs.tf               # Environment-level outputs
```

## Module Overview

Each module follows a consistent structure with the following files:

- **main.tf**: Contains resource definitions and logic
- **variables.tf**: Defines input variables with descriptions and types
- **outputs.tf**: Declares outputs for use by consumers
- **versions.tf**: Specifies provider version constraints
- **README.md**: Module-specific documentation

### Key Modules

- **VPC Module**: Manages Virtual Private Cloud, CIDR blocks, and DNS configuration
- **Subnet Module**: Creates and manages public and private subnets across availability zones
- **NAT Gateway Module**: Provides outbound internet access for private subnets
- **Security Group Module**: Manages ingress and egress rules for resources
- **EKS Module**: Provisions the Kubernetes control plane cluster
- **Node Group Module**: Manages worker node groups for EKS
- **RDS Module**: Creates managed relational databases
- **ALB Module**: Configures application load balancer for ingress traffic

## Prerequisites

### Required Tools

- **Terraform**: v1.3 or later ([Download](https://www.terraform.io/downloads.html))
- **AWS CLI**: v2.x ([Install](https://aws.amazon.com/cli/))
- **kubectl**: v1.27+ ([Install](https://kubernetes.io/docs/tasks/tools/))
- **AWS Account**: With appropriate permissions

### AWS Permissions

You'll need IAM permissions for:
- VPC and networking resources
- EKS and EC2 resources
- RDS and database resources
- IAM roles and policies
- S3 (for Terraform state)
- DynamoDB (for state locking)

### Environment Variables

```bash
export AWS_REGION=us-east-1
export AWS_PROFILE=your-profile
```

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd aws-infrastructure
```

### 2. Configure AWS Credentials

```bash
aws configure --profile production
```

### 3. Initialize Terraform

```bash
cd production
terraform init
```

### 4. Review the Plan

```bash
terraform plan -out=tfplan
```

### 5. Apply Configuration

```bash
terraform apply tfplan
```

## Deployment Workflow

### Development Workflow

1. Create a feature branch for your changes
2. Modify module code and test locally
3. Format and validate:
   ```bash
   terraform fmt -recursive .
   terraform validate
   ```
4. Create a pull request
5. GitHub Actions will automatically run `terraform plan`
6. Review the plan output in the PR comments
7. Merge PR to trigger `terraform apply`

### Manual Deployment

```bash
cd production

# Initialize Terraform (creates .terraform and downloads modules)
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive .

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Destroy infrastructure (if needed)
terraform destroy
```

## Backend Configuration

The repository uses an S3 backend with DynamoDB for state locking:

```hcl
backend "s3" {
  bucket         = "terraform-state-bucket"
  key            = "production/terraform.tfstate"
  region         = "us-east-1"
  encrypt        = true
  dynamodb_table = "terraform-locks"
}
```

### Setup S3 Backend (First-Time Only)

```bash
# Create S3 bucket
aws s3api create-bucket \
  --bucket terraform-state-bucket-$(date +%s) \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket terraform-state-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

## Best Practices

### Terraform Best Practices

1. **State Management**
   - Always use remote state (S3 + DynamoDB)
   - Enable state locking to prevent concurrent modifications
   - Enable encryption for state files

2. **Modularity**
   - Keep modules focused and single-purpose
   - Use variables for all configurable values
   - Export outputs for module composition

3. **Code Quality**
   - Run `terraform fmt` before commits
   - Run `terraform validate` in CI/CD
   - Use `terraform plan` before applying changes
   - Review plans carefully before applying

4. **Security**
   - Never hardcode sensitive values
   - Use AWS Secrets Manager for secrets
   - Enable encryption on all data at rest and in transit
   - Use VPC endpoints for private communication

5. **Documentation**
   - Document all variables with descriptions
   - Document all outputs
   - Maintain module-level README files
   - Keep README updated as infrastructure evolves

### AWS Best Practices

1. **Networking**
   - Use multiple availability zones for high availability
   - Separate public and private subnets
   - Use security groups for network segmentation

2. **Compute**
   - Use managed services when possible (EKS, RDS)
   - Implement auto-scaling for workloads
   - Use spot instances for cost optimization where appropriate

3. **Databases**
   - Enable automated backups
   - Use read replicas for high availability
   - Implement multi-AZ deployments for production

4. **Monitoring**
   - Enable CloudWatch monitoring for all resources
   - Set up CloudWatch alarms for critical metrics
   - Implement centralized logging

## Variable Management

### Variable Hierarchy

1. **Default values** in module `variables.tf`
2. **terraform.tfvars** for environment-specific values
3. **Command-line flags** for overrides: `-var 'key=value'`

### Example terraform.tfvars

```hcl
aws_region              = "us-east-1"
environment             = "production"
project_name            = "my-project"
vpc_cidr                = "10.0.0.0/16"
availability_zones      = ["us-east-1a", "us-east-1b"]
kubernetes_version      = "1.27"
node_instance_types     = ["t3.medium"]
desired_capacity        = 3
```

## Outputs

After successful deployment, Terraform will output important resource information:

```bash
# View outputs
terraform output

# Get specific output
terraform output -raw eks_cluster_name
```

Common outputs include:
- EKS cluster name and endpoint
- VPC ID and subnet IDs
- RDS endpoint and port
- ALB DNS name

## Troubleshooting

### Common Issues

1. **State Lock**
   ```bash
   # View lock status
   aws dynamodb get-item \
     --table-name terraform-locks \
     --key '{"LockID": {"S": "production"}}'
   
   # Force unlock (use with caution)
   terraform force-unlock <LOCK_ID>
   ```

2. **Plan Shows Unexpected Changes**
   - Refresh state: `terraform refresh`
   - Import resources: `terraform import module.name.resource_type resource_id`

3. **Provider Issues**
   - Upgrade provider: `terraform init -upgrade`
   - Clear cache: `rm -rf .terraform/`

## Contributing

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes and test locally
3. Format code: `terraform fmt -recursive .`
4. Validate: `terraform validate`
5. Commit with clear messages
6. Create pull request
7. Address review comments
8. Merge after approval

## Deployment Checklist

Before deploying to production:

- [ ] All code is reviewed and approved
- [ ] `terraform plan` shows expected changes only
- [ ] State backup is available
- [ ] Team is aware of deployment timing
- [ ] Rollback plan is documented
- [ ] Monitoring is configured
- [ ] Alarms are tested

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)

## Support

For issues, questions, or improvements:
1. Check existing GitHub issues
2. Review module README files
3. Consult Terraform and AWS documentation
4. Create a new issue with detailed description

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.
