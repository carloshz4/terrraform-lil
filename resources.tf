resource "aws_vpc" "env_example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_terraform"
  }
}

resource "aws_subnet" "subnet1" {
  cidr_block = "${cidrsubnet(aws_vpc.env_example.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.env_example.id}"
  availability_zone = "us-east-2a"
   tags = {
      Name = "subnet_terraform_1"
  }
}

resource "aws_subnet" "subnet2" {
  cidr_block = "${cidrsubnet(aws_vpc.env_example.cidr_block, 3, 2)}"
  vpc_id = "${aws_vpc.env_example.id}"
  availability_zone = "us-east-2b"
  tags = {
      Name = "subnet_terraform_2"
  }
}


resource "aws_subnet" "subnet3" {
  cidr_block = "${cidrsubnet(aws_vpc.env_example.cidr_block, 3, 4)}"
  vpc_id = "${aws_vpc.env_example.id}"
  availability_zone = "us-east-2c"
  tags = {
      Name = "subnet_terraform_3"
  }
}


resource "aws_security_group" "SG_terraform" {
  vpc_id = "${aws_vpc.env_example.id}"

  ingress {
    cidr_blocks = [
        "${aws_vpc.env_example.cidr_block}"
    ]

    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  tags = {
      Name = "SG_terraform"
  }

}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values= ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "ec2_terraform" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  tags = {
    Name = "my_ec2_terraform"
  }

  subnet_id = "${aws_subnet.subnet2.id}"
}
