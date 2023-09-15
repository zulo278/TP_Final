
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# VPC
resource "aws_vpc" "kubernetes_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "kubernetes-lucas"
  }
}

# Subnet
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "kubernetes-lucas"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "kubernetes_igw" {
  vpc_id = aws_vpc.kubernetes_vpc.id
}

resource "aws_main_route_table_association" "kubernetes_route_table_association" {
  vpc_id         = aws_vpc.kubernetes_vpc.id
  route_table_id = aws_route_table.kubernetes_route_table.id
}


# Route Tables
resource "aws_route_table" "kubernetes_route_table" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  tags = {
    Name = "kubernetes"
  }
}

resource "aws_route" "kubernetes_route" {
  route_table_id         = aws_route_table.kubernetes_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kubernetes_igw.id
}

# Security Groups (aka Firewall Rules)
resource "aws_security_group" "kubernetes_security_group" {
  name        = "kubernetes"
  description = "Kubernetes security group"
  vpc_id      = aws_vpc.kubernetes_vpc.id
}

# Ingress Rules for Security Group
resource "aws_security_group_rule" "kubernetes_ingress_rule_1" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}


resource "aws_security_group_rule" "kubernetes_ingress_rule_2" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.200.0.0/16"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}

resource "aws_security_group_rule" "kubernetes_ingress_rule_3" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}

resource "aws_security_group_rule" "kubernetes_ingress_rule_4" {
  type        = "ingress"
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}

resource "aws_security_group_rule" "kubernetes_ingress_rule_5" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}

resource "aws_security_group_rule" "kubernetes_ingress_rule_6" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kubernetes_security_group.id
}

# Kubernetes Public Access - Create a Network Load Balancer
resource "aws_lb" "kubernetes_lb" {
  name               = "kubernetes"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.kubernetes_subnet.id]
}

resource "aws_lb_target_group" "kubernetes_target_group" {
  name     = "kubernetes"
  protocol = "TCP"
  port     = 6443
  vpc_id   = aws_vpc.kubernetes_vpc.id
  target_type = "ip"
}


resource "aws_lb_listener" "kubernetes_listener" {
  load_balancer_arn = aws_lb.kubernetes_lb.arn
  protocol          = "TCP"
  port              = 443

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes_target_group.arn
  }
}
