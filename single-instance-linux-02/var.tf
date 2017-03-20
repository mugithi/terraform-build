variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REIGON" {
	default="us-east-1"
}
variable "AMIS" {
	type = "map"
  default = {
		us-east-1="ami-2757f631"
		us-west-2="ami-7ac6491a"
		us-west-1="ami-44613824"
	}
}

variable "PATH_TO_PRIVATE_KEY" {
	default ="mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
