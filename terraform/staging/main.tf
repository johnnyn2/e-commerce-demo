module "ecommerce-demo" {
    source = "../resources"
    env = "staging"
    eks_instance_type = "t2.micro"
}