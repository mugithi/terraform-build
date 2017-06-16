#### Terraform Deploy Docker EE on ESXi 

- You will need to create a vars.tf with your VCenter credentials

```
variable "vsphere_user" {
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  default = "Password"
}
variable "vsphere_server" {
  default = "10.10.10.10"
}

```

- You also need use ```ssh-keygen -t rsa docker``` to create public and secret keys. You can use any key name but you will have to modify the main.tf


- Terraform Apply