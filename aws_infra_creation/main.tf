// This Terraform configuration creates an AWS VPC with a specified CIDR block.
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

// This Terraform configuration creates two subnets in the VPC, each in a different availability zone.
resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subnet2"
  }
}

// This Terraform configuration creates two subnets in the VPC, each in a different availability zone.
resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet1"
  }
}

// This Terraform configuration creates an Internet Gateway and attaches it to the VPC.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

// This Terraform configuration creates a route table for the VPC and adds a route to the Internet Gateway.
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

// This Terraform configuration associates the route table with the two subnets created earlier.
resource "aws_route_table_association" "sub1_association" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.routetable.id
}

resource "aws_route_table_association" "sub2_association" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.routetable.id
}

// This Terraform configuration creates a security group that allows inbound SSH traffic from anywhere.
resource "aws_security_group" "mysg" {
  vpc_id      = aws_vpc.myvpc.id
  description = "Allow SSH and HTTP"

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (change for security)
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// This Terraform configuration creates an EC2 instance in the first subnet with the security group attached.
resource "aws_instance" "myec2" {
  ami                    = "ami-020cba7c55df1f615" # Replace with a valid AMI ID for your region
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub1.id
  associate_public_ip_address = true
  user_data              = base64encode(file("userdata.sh"))

  tags = {
    Name = "MyEC2Instance1"
  }
}

// This Terraform configuration creates a second EC2 instance in the second subnet with the security group attached.
resource "aws_instance" "myec2_2" {
  ami                    = "ami-020cba7c55df1f615" # Replace with a valid AMI ID for your region
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub2.id
  associate_public_ip_address = true
  user_data              = base64encode(file("userdata1.sh"))

  tags = {
    Name = "MyEC2Instance2"
  }
}

// load balancer configuration
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  enable_deletion_protection = false

  tags = {
    Name = "MyLoadBalancer"
  }
}

// This Terraform configuration creates a target group for the load balancer.
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }

  tags = {
    Name = "MyTargetGroup"
  }
}

// Target group attachment for the first EC2 instance
resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.myec2.id
  port             = 80
}

// Target group attachment for the second EC2 instance
resource "aws_lb_target_group_attachment" "my_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.myec2_2.id
  port             = 80
}

// This Terraform configuration creates a listener for the load balancer that forwards traffic to the target group.
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }

  tags = {
    Name = "MyListener"
  }
}