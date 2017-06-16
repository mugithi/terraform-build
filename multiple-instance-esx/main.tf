variable "control_volume_size" { default = 20 }
variable "template" { default = "Templates/centos7tmpl"}
variable "disk_type" { default = "thin" }
variable "datastore" { default = "VNX-3TB-Datastore"}
variable "short_name" {default = "docker-swarm"}
variable "folder" {default = ""}
variable "linked_clone" { default = false }
variable "control_count" {default = 7 }
variable "dns_server1" { default = "172.17.60.11" }
variable "dns_server2" { default = "172.17.60.12" }
variable "ssh_user" { default = "root" }
variable "ssh_private_key" { default ="./docker" }
variable "ssh_public_key" { default ="./docker.pub" }
/*variable "pool" { default = "7200-Cluster/Resources/RP_NAME"}*/
# Configure the VMware vSphere Provider



provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}


resource "null_resource" "pre-flight" {
  provisioner "local-exec" {
    command = "rm ./inventory"
  }
}


resource "vsphere_virtual_machine" "new" {
  depends_on = ["null_resource.pre-flight"]
  name   = "${var.short_name}-terraform-${format("%02d", count.index+1)}"
  datacenter    = "Datacenter"
  folder = "${var.folder}"
  cluster = "7200-Cluster"

  vcpu   = 2
  memory = 4096

  linked_clone = "${var.linked_clone}"


  disk {
    /*size = "${var.control_volume_size}"*/
    template = "${var.template}"
    type = "${var.disk_type}"
    datastore = "${var.datastore}"
  }

  network_interface {
    label              = "7200VLAN101"
  }

  dns_servers = ["${var.dns_server1}", "${var.dns_server2}"]
  count = "${var.control_count}"

  provisioner "local-exec" {
    command = "printf \"\n[${var.short_name}-terraform-${format("%02d", count.index+1)}]\n${self.network_interface.0.ipv4_address} ansible_connection=ssh ansible_ssh_user=root ansible_ssh_common_args='-o StrictHostKeyChecking=no'\" >> inventory"
  }

}

resource "null_resource" "post-flight" {
  depends_on = ["vsphere_virtual_machine.new"]
  provisioner "local-exec" {
    command = "sleep 30 && ansible-playbook -i inventory ansible-install-docker.yml -e 'host_key_checking=False' --private-key ${var.ssh_private_key}"

  }

}



output "control_ips" {
  value = "${join(",", vsphere_virtual_machine.new.*.network_interface.0.ipv4_address)}"
}
