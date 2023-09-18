# Compute Instances

# Instance Image
data "aws_ami" "aws" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# SSH Key Pair
resource "aws_key_pair" "kubernetes_key_pair" {
  key_name   = "kubernetes-lucas"
  public_key = file("../Files/kubernetes-lucas.pub")
}

# Kubernetes Controllers
resource "aws_instance" "kubernetes_controllers" {
  count = 1
  ami           = "ami-008bcc0a51a849165"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.kubernetes_subnet.id
  key_name      = aws_key_pair.kubernetes_key_pair.key_name
  associate_public_ip_address = true
  private_ip = "10.0.1.1${count.index}"
  security_groups = [aws_security_group.kubernetes_security_group.id]

  user_data = <<-EOF
    #cloud-config
    name: lucas-controller-${count.index}
    EOF

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "controller-${count.index}"
  }
}

# Kubernetes Workers
resource "aws_instance" "kubernetes_workers" {
  count = 2

  ami           = "ami-008bcc0a51a849165"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.kubernetes_subnet.id
  key_name      = aws_key_pair.kubernetes_key_pair.key_name
  associate_public_ip_address = true
  private_ip = "10.0.1.2${count.index}"
  security_groups = [aws_security_group.kubernetes_security_group.id]

  user_data = <<-EOF
    #cloud-config
    name: lucas-worker-${count.index}
    pod-cidr: 10.200.${count.index}.0/24
    EOF

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "worker-${count.index}"
  }
}
