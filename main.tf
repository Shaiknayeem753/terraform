provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATGYN6IGWB4R5YBDJ"
  secret_key = "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"
}

resource "aws_vpc" "main" {
  cidr_block       = "192.168.10.0/25"
  instance_tenancy = "default"

  tags = {
    Name = "tf vpc"
  }
}



resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.0/27"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "tf-subnet"
  }
}


resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["192.168.10.10"]

  tags = {
    Name = "tf_network_interface"
  }
}



resource "aws_instance" "ec2" {
  ami           = "ami-062df10d14676e201" # ap-south-1
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }



  credit_specification {
    cpu_credits = "unlimited"
  }
}
