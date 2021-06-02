resource "aws_vpc" "mytestvpc" {
  cidr_block = var.vpc_cidir
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "publicsubnet" {
  count = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.mytestvpc.id
  cidr_block        = element(var.public_subnets_cidr,count.index) 
  availability_zone = element(var.public_azs,count.index)
  tags = {
    Name = "publicsubnet-${count.index}"
  }
}

resource "aws_subnet" "privatesubnet" {
  count = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.mytestvpc.id
  cidr_block        = element(var.private_subnets_cidr,count.index) 
  availability_zone = element(var.private_azs,count.index)
  tags = {
    Name = "privatesubnet-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mytestvpc.id

  tags = {
    Name = "internet_gw"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eipnat.id
  count = 1
  subnet_id     = element(aws_subnet.publicsubnet.*.id, count.index)
  tags = {
    Name = "nat_gw"
  }
}

resource "aws_eip" "eipnat" {
  vpc = true
  tags = {
    Name = "elasticIP"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.mytestvpc.id
  count = 1
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }
  tags = {
    Name = "privateroute"
  }
}

resource "aws_default_route_table" "route" {
  default_route_table_id = aws_vpc.mytestvpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "default_publicroute"
  }

}

resource "aws_route_table_association" "privateasso1" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.privatesubnet.*.id,count.index)
  route_table_id = element(aws_route_table.privateroute.*.id,count.index)
}


resource "aws_route_table_association" "defaultroute_asso" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.publicsubnet.*.id, count.index)
  route_table_id = aws_vpc.mytestvpc.default_route_table_id
}

