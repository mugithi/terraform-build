# Uncomment if you want to have autoscaling notifications

resource "aws_sns_topic" "example-sns" {
  name         = "${var.AWS-AUTO-SCALING-NAME}-sns"
  display_name = "${var.AWS-AUTO-SCALING-NAME} ASG SNS topic"
} # email subscription is currently unsupported in terraform and can be done using the AWS Web Console

resource "aws_autoscaling_notification" "example-notify" {
  group_names = ["${aws_autoscaling_group.ecs-example-autoscaling.name}"]
  topic_arn     = "${aws_sns_topic.example-sns.arn}"
  notifications  = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
}
