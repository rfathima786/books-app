data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "eks-cluster-cloud"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

#get vpc data
data "aws_vpc" "default" {
  default = true
}
#get public subnets for cluster
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["public"]
  }
 }
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
 filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["private"]
  }

}
data "aws_availability_zones" "selected" {
  state = "available"
 
}

locals {
  target_azs = ["us-east-1a", "us-east-1b"]  # At least two
}

data "aws_subnets" "control_plane" {
  for_each = toset(local.target_azs)
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = [each.value]
  }
  filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["public"]
  }
  # filter {
  #   name   = "tag:Type"  # Or your public tag, e.g., "public"
  #   values = ["private"]
  # }
}

locals {
  control_plane_subnet_ids = flatten([for az, ds in data.aws_subnets.control_plane : ds.ids])
}


#cluster provision
resource "aws_eks_cluster" "example" {
  name     = "EKS_CLOUD"
  role_arn = aws_iam_role.example.arn
 vpc_config {
  
       subnet_ids   = local.control_plane_subnet_ids  # Now spans 3+ AZs

 }
 


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "example1" {
  name = "eks-node-group-cloud"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example1.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example1.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example1.name
}

#create node group
data "aws_vpc" "default_2" {
  default = true
}
#get public subnets for cluster
data "aws_subnets" "public_2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["public"]
  }
 }
data "aws_subnets" "private_2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
 filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["private"]
  }
}
data "aws_availability_zones" "selected_1" {
  state = "available"
 
}

locals {
  target_1_azs = ["us-east-1c", "us-east-1d"]  # At least two
}

data "aws_subnets" "control_plane_1" {
  for_each = toset(local.target_1_azs)
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = [each.value]
  }
  filter {
    name   = "tag:Type"  # Or your public tag, e.g., "public"
    values = ["public"]
  }
  # filter {
  #   name   = "tag:Type"  # Or your public tag, e.g., "public"
  #   values = ["private"]
  # }
}

locals {
  control_plane_1_subnet_ids = flatten([for az, ds in data.aws_subnets.control_plane_1: ds.ids])
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "Node-cloud"
  node_role_arn   = aws_iam_role.example1.arn
  subnet_ids      = local.control_plane_1_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t2.medium"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}