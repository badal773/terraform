# Define the GCP provider
# 1st login to gcp 
# https://cloud.google.com/docs/terraform/authentication
# gcloud compute ssh --zone "var.zone_name" "var.machine_name" --project "var.project_id"
# terraform plan -var-file varaibles.tfvars
# terraform apply -auto-approve  -var-file varaibles.tfvars
# terraform destroy -auto-approve  -var-file varaibles.tfvars


provider "google" {
  project = var.project_id
  region  = var.region_name
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

# Create a public subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = var.subnet_name

  ip_cidr_range = "10.0.1.0/24"
  region        = var.region_name
  network       = google_compute_network.vpc_network.id
}

# Define a firewall rule to allow all ports
resource "google_compute_firewall"  "allow_all" {
  name    = "allow-all-traffic"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  source_ranges = ["0.0.0.0/0"] # Open to public
}

# Define an Ubuntu instance
resource "google_compute_instance"  "vm_instance" {
  name         = var.machine_name
  machine_type = var.instance_type
  zone         = var.zone_name


# Explanation of Changes:
# preemptible = true → Enables Spot (previously called preemptible) instances.
# automatic_restart = false → Ensures the instance does not restart automatically when stopped.
# provisioning_model = "SPOT" → (Optional but recommended) Explicitly defines the provisioning model.


  scheduling {
    preemptible = true   # Enable Spot instance (preemptible)
    automatic_restart = false  # Recommended for Spot instances
    provisioning_model = "SPOT" # Explicitly define Spot provisioning
  }

  # Set a custom hostname below
  hostname = var.host_name

  boot_disk {
    initialize_params {
      image = "ubuntu-2404-lts-amd64"
      size  = var.disk_size 

    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {} 
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }
}

# Variables
variable "machine_name" {
  description = "The name of the instance"
  type        = string
  default     = "vm-by-badal773"
}
variable "host_name" {
  description = "The name of the host as gcp makes a very long host vmname.zone.c.projectname.internal"
  type        = string
  default     = "ubuntu.internal"
}


variable "region_name" {
  description = "The region for the instance"
  type        = string
  default     = "asia-south1"
}

variable "disk_size" {
  description = "Specify the disk size in GB"
  type        = string
  default     = "50"
}

variable "zone_name" {
  description = "The zone for the instance"
  type        = string
  default     = "asia-south1-a"
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "n2-standard-4"
}

variable "project_id" {
  description = "The project ID for GCP account"
  type        = string
  default     = "**********"
}

variable "vpc_name" {
  description = "The name of the existing VPC"
  type        = string
  default     = "default" # Change if your default VPC has a specific name
}

variable "subnet_name" {
  description = "The name of the subnet in the VPC (optional)"
  type        = string
  default     = "default" 
}
variable "gcp_ssh_pub_key_file" {
  description = "The path of the key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "gcp_ssh_user" {
  description = "The name of the user"
  type        = string
  default     = "ubuntu"
}




# Outputs
output "vpc_network_id" {
  description = "The ID of the VPC network created."
  value       = google_compute_network.vpc_network.id
}

output "subnet_id" {
  description = "The ID of the public subnet created."
  value       = google_compute_subnetwork.public_subnet.id
}

output "firewall_rule_name" {
  description = "The name of the firewall rule allowing all ports."
  value       = google_compute_firewall.allow_all.name
}

output "instance_name" {
  description = "The name of the Ubuntu instance created."
  value       = google_compute_instance.vm_instance.name
}

output "public_ip" {
  description = "The public IP address of the Ubuntu instance. ssh <username>@<ip> -o UserKnownHostsFile=/dev/null"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "startup_script_log_path" {
  description = "The log file path on the VM for the startup script."
  value       = "/tmp/initscript.log"
}
