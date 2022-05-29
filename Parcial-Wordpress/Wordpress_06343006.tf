########### Se indica el provider Digial Ocean #################################

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.20.0"
    }
  }
}

########### Variables declaradas en el archivo terraform.tfvars ################

variable "do_token" {}

variable "ssh_key_private1" {}
variable "droplet_ssh_key_id1" {}
variable "droplet_name1" {}
variable "droplet_size1" {}
variable "droplet_region1" {}

variable "ssh_key_private2" {}
variable "droplet_ssh_key_id2" {}
variable "droplet_name2" {}
variable "droplet_size2" {}
variable "droplet_region2" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

################ Se crea la VPC ##################

resource "digitalocean_vpc" "NetworkParcial" {
  name   = "NetworkParcial"
  region = "nyc1"
  ip_range = "192.168.10.0/24"
}

################ Crear Droplet no 1 ############## 

resource "digitalocean_droplet" "myblog1" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name1}"
    region = "${var.droplet_region1}"
    size   = "${var.droplet_size1}"
    monitoring = "true"
    ssh_keys = ["${var.droplet_ssh_key_id1}"]
    vpc_uuid = digitalocean_vpc.NetworkParcial.id

    # Install python on the droplet using remote-exec to execute ansible playbooks to configure the services
    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private1}")}"
        }
    }

    # Execute ansible playbooks using local-exec 
    provisioner "local-exec" {
        environment = {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }

        working_dir = "/Users/gvaldez/devops/parcial/Parcial-TerraformWordpress/playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private1} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}

################ Crear Droplet no 1 ############## 

resource "digitalocean_droplet" "myblog2" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name2}"
    region = "${var.droplet_region2}"
    size   = "${var.droplet_size2}"
    monitoring = "true"
    ssh_keys = ["${var.droplet_ssh_key_id2}"]
    vpc_uuid = digitalocean_vpc.NetworkParcial.id

    # Install python on the droplet using remote-exec to execute ansible playbooks to configure the services
    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private2}")}"
        }
    }

    # Execute ansible playbooks using local-exec 
    provisioner "local-exec" {
        environment = {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }

        working_dir = "/Users/gvaldez/devops/parcial/Parcial-Wordpress/playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private2} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}

################ Crear loadbalance en digitalocean para Wordpress ############## 

resource "digitalocean_loadbalancer" "www-parcial" {
  name = "www-parcial"
  region = "nyc1"
  vpc_uuid = digitalocean_vpc.NetworkParcial.id


  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 80
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.myblog1.id, digitalocean_droplet.myblog2.id ]
}