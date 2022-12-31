module "ecommerce-demo" {
    source = "../resources"
    env = "dev"
    eks_instance_type = "t2.micro"
}