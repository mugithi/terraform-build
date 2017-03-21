data "aws_route53_zone" "isaack-io" {
   name = "isaack.io"
}

resource "aws_route53_record" "server1-record" {
   zone_id = "${data.aws_route53_zone.isaack-io.zone_id}"
   name = "${var.AWS-AUTO-SCALING-NAME}.isaack.io"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.myapp-elb.dns_name}"]
}
/*resource "aws_route53_record" "www-record" {
   zone_id = "${aws_route53_zone.isaack-io.zone_id}"
   name = "www.isaack.io"
   type = "A"
   ttl = "300"
      records = ["${aws_instance.example.public_ip}"]
}
resource "aws_route53_record" "mail1-record" {
   zone_id = "${aws_route53_zone.isaack-io.zone_id}"
   name = "isaack.io"
   type = "MX"
   ttl = "300"
   records = [
     "1 aspmx.l.google.com.",
     "5 alt1.aspmx.l.google.com.",
     "5 alt2.aspmx.l.google.com.",
     "10 aspmx2.googlemail.com.",
     "10 aspmx3.googlemail.com."
   ]
}

output "ns-servers" {
   value = "${aws_route53_zone.isaack-io.name_servers}"
}*/
