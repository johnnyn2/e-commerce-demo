provider "aws" {
    region = "ap-east-1"
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

locals {
    cluster_name = "e-commerce-demo-cluster"
}

provider "kubernetes" {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.cluster.token
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.18.1"
    name = "e-commerce-k8s-vpc"
    cidr = "172.16.0.0/16"
    azs = data.aws_availability_zones.available.names
    private_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
    public_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    public_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"             = "1"
    }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "18.30.3"
    cluster_name = "${local.cluster_name}"
    cluster_version = "1.24"
    subnet_ids = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id
    eks_managed_node_groups = {
        first = {
            desired_capacity = 1
            max_capacity = 10
            min_capacity = 1
            instance_type = var.eks_instance_type
        }
    }
}

module "eks-kubeconfig" {
    source = "hyperbadger/eks-kubeconfig/aws"
    version = "1.0.0"
    depends_on = [
      module.eks
    ]
    cluster_id = module.eks.cluster_id
}

resource "local_file" "kubeconfig" {
    content = module.eks-kubeconfig.kubeconfig
    filename = "kubeconfig_${local.cluster_name}"
}

resource "aws_iam_policy" "worker_policy" {
    name = "worker-policy"
    description = "worker policy for the ALB Ingress"
    policy = file("iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "additional" {
    for_each = module.eks.eks_managed_node_groups
    policy_arn = aws_iam_policy.worker_policy.arn
    role = each.value.iam_role_name
}