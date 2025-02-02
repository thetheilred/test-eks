# module "eks" {
#   depends_on      = [module.vpc]
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = "eks-dev-cluster"
#   cluster_version = "1.31"
#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   cluster_endpoint_public_access           = true
#   enable_cluster_creator_admin_permissions = true

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = module.vpc.public_subnets

#   eks_managed_node_groups = {
#     example = {
#       ami_type      = "AL2023_x86_64_STANDARD"
#       instance_type = "m5.large"

#       min_size         = 2
#       max_size         = 5
#       desired_capacity = 2
#     }
#   }

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

resource "aws_eks_cluster" "example" {
  name = "example"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.example.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = module.vpc.private_subnet_arns
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}