module "ecommerce-demo" {
    source = "../resources"
    env = "prod"
    eks_instance_type = "t2.micro"
}