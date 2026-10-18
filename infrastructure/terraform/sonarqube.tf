data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "cloudops-sonarqube-sg"
  description = "Security group for SonarQube"
  vpc_id      = aws_vpc.cloudops_vpc.id

  ingress {
    description = "SonarQube web interface"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudops-sonarqube-sg"
  }
}

resource "aws_instance" "sonarqube" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "c7i-flex.large"

  subnet_id = aws_subnet.public_subnet_1.id

  vpc_security_group_ids = [
    aws_security_group.sonarqube_sg.id
  ]

  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "cloudops-sonarqube"
  }
  user_data_replace_on_change = true
  user_data                   = <<-EOF
#!/bin/bash

cat <<SYSCTL > /etc/sysctl.d/99-sonarqube.conf
vm.max_map_count=524288
fs.file-max=131072
SYSCTL

sysctl --system

dnf update -y
dnf install -y docker

systemctl enable docker
systemctl start docker

docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  sonarqube:community
EOF
}