resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_address_space
    enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "ec2lab-igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_subnet" "subnet1" {
    cidr_block = var.subnet1_address_space
    vpc_id = aws_vpc.myvpc.id
    map_public_ip_on_launch = "true"
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "subnet2" {
    cidr_block = var.subnet2_address_space
    vpc_id = aws_vpc.myvpc.id
    map_public_ip_on_launch = "true"
    availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_route_table" "routetable1" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ec2lab-igw.id
    }
}

resource "aws_route_table_association" "associate_subnet1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.routetable1.id
}

resource "aws_security_group" "ngnix_ec2_sg" {
    name = "ngnix_ec2_sg"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nginx1" {
    ami = data.aws_ami.aws-linux.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.ngnix_ec2_sg.id]
    key_name = var.key_name
    user_data = file("userdata.sh")
}