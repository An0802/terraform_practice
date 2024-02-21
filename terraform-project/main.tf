
resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"

tags = {
Name = "My VPC"
}
}

resource "aws_subnet" "public" {
vpc_id            = aws_vpc.main.id
cidr_block        = "10.0.1.0/24"
availability_zone = "us-east-1a" # Replace with your desired AZ

tags = {
Name = "Public Subnet"
}
}

resource "aws_internet_gateway" "gw" {
vpc_id = aws_vpc.main.id

tags = {
Name = "Internet Gateway"
}
}

resource "aws_route_table" "public_route_table" {
vpc_id = aws_vpc.main.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}

tags = {
Name = "Public Route Table"
}
}

resource "aws_route_table_association" "public_subnet_route_table_assoc" {
    subnet_id         = aws_subnet.public.id
    route_table_id    = aws_route_table.public_route_table.id
    }

    resource "aws_security_group" "ssh" {
        name = "SSH"
        vpc_id = aws_vpc.main.id
        
        ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Restrict this for production environments

        }
        
        egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
        
        tags = {
        Name = "SSH Security Group"
        }
    }

        resource "aws_instance" "webserver" {
            ami           = "ami-0c7217cdde317cfec" # Replace with your desired AMI
            instance_type = "t2.micro" # Replace with your desired instance type
            vpc_security_group_ids = [aws_security_group.ssh.id]
            subnet_id = aws_subnet.public.id
            associate_public_ip_address = true
            key_name = "IBM-KP"
            
            tags = {
            Name = "Web Server"
            }
        }
            
        
#Consider adding user data script for initial configuration
#user_data = file("user_data.sh")

# Consider adding volume configurations for persistent storage

# # ...


# Output the public IP address of the instance

output "public_ip" {
value = aws_instance.webserver.public_ip
}