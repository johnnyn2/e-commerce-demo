provider "helm" {
    kubernetes {
        host = data.aws_eks_cluster.cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
        token = data.aws_eks_cluster_auth.cluster.token
    }
}

// deploy ingress controller which is AWS ALB
resource "helm_release" "ingress" {
    name = "ingress"
    chart = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    version = "1.4.6"
    set {
        name  = "autoDiscoverAwsRegion"
        value = "true"
    }
    set {
        name  = "autoDiscoverAwsVpcID"
        value = "true"
    }
    set {
        name  = "clusterName"
        value = local.cluster_name
    }
}

// deploy the application which include ingress rules
resource "helm_release" "app" {
    name = "application"
    chart = "ecommerce-demo"
    repository = "https://mygithubpages.io/ecommerce-demo-charts"
    version = "0.1.0"
}