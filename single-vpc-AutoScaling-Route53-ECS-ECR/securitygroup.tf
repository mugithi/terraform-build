resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.terraform.id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "${var.VPC_NAME}-allow-ssh"
  }
}

resource "aws_security_group" "allow-http-fromlb-to-instances" {
  vpc_id = "${aws_vpc.terraform.id}"
  name = "allow-http-fromlb-to-instances"
  description = "security group that allow-http-fromlb-to-instances"

  ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      security_groups = ["${aws_security_group.allow-http-forlb.id}"]
  }
tags {
    Name = "${var.VPC_NAME}-allow-http-fromlb-to-instances"
  }
}

resource "aws_security_group" "allow-http-forlb" {
  vpc_id = "${aws_vpc.terraform.id}"
  name = "allow-http-forlb"
  description = "security group that allows port 80 and all egress traffic for load_balancers"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "${var.VPC_NAME}-allow-http-forlb"
  }
}
