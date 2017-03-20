resource "aws_instance" "example" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.terraform-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykey.key_name}"

  #Root Volume
  root_block_device {
    volume_size = 16
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "${var.AWS_INSTANCE_NAME}"
  }
}


resource "aws_key_pair" "mykey" {
  key_name = "mykey"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_ebs_volume" "ebs-volume-02" {
  availability_zone = "us-east-1a"
  size = 20
  type = "gp2"
  tags {
    Name = "ebs-volume-02"
  }
}

resource "aws_volume_attachment" "ebs-volume-02-attachment" {
  device_name = "/dev/xvdh"
  volume_id ="${aws_ebs_volume.ebs-volume-02.id}"
  instance_id="${aws_instance.example.id}"
}
