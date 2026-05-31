resource "aws_eks_cluster" "main" {
  name     = "axiom-${var.environment}"
  role_arn = var.app_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = "axiom-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "axiom-${var.environment}-nodes"
  node_role_arn   = var.app_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 2
  }

  instance_types = ["t3.large"]

  tags = {
    Environment = var.environment
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "axiom-${var.environment}-cache-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "axiom-${var.environment}-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  port                 = 6379
}
