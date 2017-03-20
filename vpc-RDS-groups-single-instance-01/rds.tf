resource "aws_db_subnet_group" "mariadb-subnet" {
    name = "mariadb-subnet"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.terraform-private-1.id}","${aws_subnet.terraform-private-2.id}"]
}

resource "aws_db_parameter_group" "mariadb-parameters" {
    name = "mariadb-parameters"
    family = "mariadb10.1"
    description = "MariaDB parameter group"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
   }

}


resource "aws_db_instance" "mariadb" {
  allocated_storage    = 100    # 100 GB of storage, gives us more IOPS than a lower number
  engine               = "mariadb"
  engine_version       = "10.1.14"
  instance_class       = "db.t2.micro"    # use micro if you want to use the free tier
  identifier           = "mariadb"
  name                 = "mariadb"
  username             = "root"   # username
  password             = "${var.RDS_PASSWORD}" # password
  db_subnet_group_name = "${aws_db_subnet_group.mariadb-subnet.name}"
  parameter_group_name = "mariadb-parameters"
  multi_az             = "true"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = ["${aws_security_group.allow-mariadb.id}"]
  storage_type         = "gp2"
  backup_retention_period = 30    # how long you’re going to keep your backups
  availability_zone = "${aws_subnet.terraform-private-2.availability_zone}"   # prefered AZ
  tags {
      Name = "${var.AWS_INSTANCE_NAME}-mariadb-instance"
  }
}
