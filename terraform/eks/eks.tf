module "eks" {
  depends_on      = [module.vpc]
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-dev-cluster"
  cluster_version = "1.31"
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    example = {
      ami_type      = "AL2023_x86_64_STANDARD"
      instance_type = "m5.large"

      min_size         = 2
      max_size         = 5
      desired_capacity = 2
    }
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
