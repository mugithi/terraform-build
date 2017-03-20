# nat gw
resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.terraform-public-1.id}"
  depends_on = ["aws_internet_gateway.main-gw"]
  
}

# VPC setup for NAT
resource "aws_route_table" "terraform-private" {
    vpc_id = "${aws_vpc.terraform.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    }

    tags {
        Name = "${var.VPC_NAME}-private-1"
    }
}
# route associations private
resource "aws_route_table_association" "terraform-private-1-a" {
    subnet_id = "${aws_subnet.terraform-private-1.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}
resource "aws_route_table_association" "terraform-private-2-a" {
    subnet_id = "${aws_subnet.terraform-private-2.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}
resource "aws_route_table_association" "terraform-private-3-a" {
    subnet_id = "${aws_subnet.terraform-private-3.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}
resource "aws_route_table_association" "terraform-private-4-a" {
    subnet_id = "${aws_subnet.terraform-private-4.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}
resource "aws_route_table_association" "terraform-private-5-a" {
    subnet_id = "${aws_subnet.terraform-private-5.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}
