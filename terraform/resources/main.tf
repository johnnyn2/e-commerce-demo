module "ecommerce-eks" {
    source = "./eks"
    env = var.env
    eks_instance_type = var.eks_instance_type
}