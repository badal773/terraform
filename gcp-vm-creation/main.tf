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
      metadata_startup_script = <<-EOT
      #!/bin/bash
      set -e  # Exit immediately if a command exits with a non-zero status
      set -x  # Enable debugging (print commands as they are executed)

      # Log file path
      LOGFILE="/tmp/initscript.log"
      exec &>> $LOGFILE  # Append both stdout and stderr to the log file

      echo "Initialization script started at $(date)"

      # Install MicroK8s
      echo "Installing MicroK8s..."
      snap install microk8s --classic --channel=1.30 || { echo "MicroK8s installation failed"; exit 1; }
      echo "MicroK8s installation completed at $(date)"

      # Setup aliases for kubectl and helm
      echo "Setting up aliases for kubectl and helm..."
      echo "alias kubectl='microk8s kubectl'" >> /home/ubuntu/.bashrc
      echo "alias helm='microk8s helm3'" >> /home/ubuntu/.bashrc
      echo "Aliases added successfully."

      # Add user to microk8s group and set ownership of .kube directory
      echo "Configuring MicroK8s group and permissions..."
      usermod -a -G microk8s devtron || { echo "Failed to add user to microk8s group"; exit 1; }
      # chown -f -R devtron ~/home/devtron 
      echo "User configuration completed."

      # Enable necessary MicroK8s services
      echo "Enabling MicroK8s services..."
      microk8s enable dns storage helm3 ingress metrics-server || { echo "Failed to enable MicroK8s services"; exit 1; }
      echo "MicroK8s services enabled successfully."

      # Install Devtron
      echo "Installing Devtron using Helm..."
      microk8s helm3 repo add devtron https://helm.devtron.ai || { echo "Failed to add Helm repo"; exit 1; }
      microk8s helm3 repo update devtron
      echo "Initialization script completed at $(date)"

      EOT
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
