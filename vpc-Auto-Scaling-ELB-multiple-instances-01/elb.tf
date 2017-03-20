resource "aws_elb" "my-elb" {
  name = "my-elb"
  subnets = ["${aws_subnet.terraform-public-1.id}", "${aws_subnet.terraform-public-2.id}", "${aws_subnet.terraform-public-3.id}", "${aws_subnet.terraform-public-4.id}", "${aws_subnet.terraform-public-5.id}"]
  security_groups = ["${aws_security_group.allow-http-forlb.id}"]
 listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.AWS-AUTO-SCALING-NAME}-elb"
  }
}
