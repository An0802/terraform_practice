resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "RDS-VPC"
  }
}

resource "aws_subnet" "database_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database-1"
  }
}

resource "aws_subnet" "database_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database-2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags={
    Name = "Internet Gateway"
  }
}

resource "aws_db_subnet_group" "rds_group" {
  name       = "subnet group"
  subnet_ids = [aws_subnet.database_subnet_1.id, aws_subnet.database_subnet_2.id]

  tags = {
    Name = "RDS-subnet-group"
  }
}

resource "aws_db_instance" "RDS" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  multi_az             = false
  name                 = "MYRDS"
  username             = "admin"
  password             = "password"
  skip_final_snapshot  = true
  publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.rds_group.id
  tags = {
    Name = "RDS database"
  }
}