resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix          = "${var.AWS-AUTO-SCALING-NAME}-launchconfig"
  image_id             = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type        = "t2.micro"
  key_name             = "${aws_key_pair.mykeypair.key_name}"
  security_groups      = ["${aws_security_group.allow-ssh.id}","${aws_security_group.allow-http-fromlb-to-instances.id}"]
  user_data            = "#!/bin/bash\napt-get -y install nginx\nMYIP=`ifconfig | grep 'addr:10' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                 = "${var.AWS-AUTO-SCALING-NAME}-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.terraform-public-1.id}", "${aws_subnet.terraform-public-2.id}", "${aws_subnet.terraform-public-3.id}", "${aws_subnet.terraform-public-4.id}", "${aws_subnet.terraform-public-5.id}"]
  launch_configuration = "${aws_launch_configuration.example-launchconfig.name}"
  min_size             = 2
  max_size             = 3
  health_check_grace_period = 300
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.my-elb.name}"]
  force_delete = true

  tag {
      key = "Name"
      value = "${var.AWS-AUTO-SCALING-NAME}-instance"
      propagate_at_launch = true
  }
}
