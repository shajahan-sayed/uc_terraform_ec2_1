resource "aws_vpc" "ec2-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
   Name = "ec2-vpc"
  }
}

resource "aws_subnet" "public_sub1" {
  vpc_id = aws_vpc.ec2-vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public_sub1"
  }
}

resource "aws_internet_gateway" "igw6" {
  vpc_id = aws_vpc.ec2-vpc.id

  tags = {
    Name = "igw6"
  }
}

resource "aws_route_table" "pub_rt6" {
 vpc_id = aws_vpc.ec2-vpc.id

 tags = {
    Name = "pub_rt6"
 }
  
}

resource "aws_route_table_association" "pub_association1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.pub_rt6.id
}

 resource "aws_route" "pub_route1" {
   gateway_id = aws_internet_gateway.igw6.id
   route_table_id         = aws_route_table.pub_rt6.id
   destination_cidr_block = "0.0.0.0/0" 
 }



#creating sg group

resource "aws_security_group" "ec2_group1" {
 name = "ec2_group1"
 description = "Allow SSH and HTTP"
 vpc_id = aws_vpc.ec2-vpc.id


 ingress {
  description = "allow ssh"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
  description = " allow http"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
  description = "allow all outbound"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }

 tags = { 
   Name = "ec2_group1"
 }
}

#creating ec2 with nginx installed

resource "aws_instance" "ec2-nginx" {
  ami = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_sub1.id
  vpc_security_group_ids = [aws_security_group.ec2_group1.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Welcome to Nginx deployed by Terraform!</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "ec2-nginx"
  }
}
 
   
 
