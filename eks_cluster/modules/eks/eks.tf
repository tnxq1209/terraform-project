# Cluster: AWS managed Kubernetes cluster(EKS), only the control plane is managed by AWS, the worker nodes are managed by the user.
resource "aws_eks_cluster" "main" {
  name = var.cluster_name

  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

# Node Group: A node group is a group of worker nodes that are managed by AWS and run in your EKS cluster. You can create multiple node groups in a cluster, and each node group can have different instance types, scaling configurations, and other settings.
resource "aws_eks_node_group" "main" {
  cluster_name = aws_eks_cluster.main.name

  node_group_name = "devboard-nodes"

  node_role_arn = var.node_role_arn

  subnet_ids = var.subnet_ids

  instance_types = ["t3.small"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}

# Addons: EKS add-ons are software components that extend the functionality of your EKS cluster. They can be used to add features such as networking, storage, and monitoring to your cluster. EKS add-ons are managed by AWS and are automatically updated to the latest version.
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"

  depends_on = [
    aws_eks_node_group.main
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"

  service_account_role_arn = var.ebs_csi_role_arn
}