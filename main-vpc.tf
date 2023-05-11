#Create the vpc
resource "aws_vpc" "mainvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mainvpc"
  }
}
#Creating IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
  tags = {

    Name = "main-igw"
  }
}

#Creating pub-subnet1
resource "aws_subnet" "pub-sub-1" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {

    Name = "pub-subnet-1"
  }

}
#Creating private subnet1
resource "aws_subnet" "pvt-sub-1" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "pvt-subnet-1"
  }
}
#Creating pub-subnet2
resource "aws_subnet" "pub-sub-2" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = "true"
  tags = {

    Name = "pub-subnet-2"
  }

}

#Creating pvt-subnet2
resource "aws_subnet" "pvt-sub-2" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "pvt-subnet-2"
  }
}

#Creating pvt-subnet3
resource "aws_subnet" "pvt-sub-3" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "pvt-subnet-3"
  }
}

#Creating pvt-subnet4
resource "aws_subnet" "pvt-sub-4" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "pvt-subnet-4"
  }
}

# Create elastic ip
resource "aws_eip" "elastic-1" {
  vpc = true
}
# Create Nat-gateway
resource "aws_nat_gateway" "nat-1" {

  allocation_id     = aws_eip.elastic-1.id
  subnet_id         = aws_subnet.pub-sub-1.id
  connectivity_type = "public"
  tags = {
    Name = "mainnat-1"
  }
}
# Create elastic ip
resource "aws_eip" "elastic-2" {
  vpc = true
}

# Create Nat-gateway
resource "aws_nat_gateway" "nat-2" {

  allocation_id     = aws_eip.elastic-2.id
  subnet_id         = aws_subnet.pub-sub-2.id
  connectivity_type = "public"
  tags = {
    Name = "mainnat-2"
  }
}
#Create Pub-Route-table
resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
  tags = {
    Name = "pub-rot"
  }

}

#Create Pvt-Route-table
resource "aws_route_table" "pvt-route-1" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1.id
  }

  tags = {
    Name = "pvt-rot-1"
  }

}

#Create Pvt-Route-table
resource "aws_route_table" "pvt-route-2" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-2.id
  }

  tags = {
    Name = "pvt-rot-2"
  }

}
#Create Pvt-Route-table
resource "aws_route_table" "pvt-route-3" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1.id
  }

  tags = {
    Name = "pvt-rot-3"
  }
}

#Create Pvt-Route-table
resource "aws_route_table" "pvt-route-4" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-2.id
  }

  tags = {
    Name = "pvt-rot-4"
  }
}
#subnets Associations
#pub-subnet-association
resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-route.id
}

#pvt subnet-association
resource "aws_route_table_association" "pvt-1" {
  subnet_id      = aws_subnet.pvt-sub-1.id
  route_table_id = aws_route_table.pvt-route-1.id

}



#subnets Associations
#pub-subnet-association
resource "aws_route_table_association" "pub-2" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.pub-route.id
}
#pvt subnet-association
resource "aws_route_table_association" "pvt-2" {
  subnet_id      = aws_subnet.pvt-sub-2.id
  route_table_id = aws_route_table.pvt-route-2.id

}
#pvt subnet-association
resource "aws_route_table_association" "pvt-3" {
  subnet_id      = aws_subnet.pvt-sub-3.id
  route_table_id = aws_route_table.pvt-route-3.id

}
#pvt subnet-association
resource "aws_route_table_association" "pvt-4" {
  subnet_id      = aws_subnet.pvt-sub-4.id
  route_table_id = aws_route_table.pvt-route-4.id

}

