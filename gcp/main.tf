provider "google" {
  credentials = file("/home/jasondoze/multicloud_terraform/gcp/gcloud-392200-fee5df76e628.json")  
  project = "gcloud-392200"  
  region  = "us-central1"  
  zone    = "us-central1-c"  
}

# Create VPC network
resource "google_compute_network" "vpc_net" {
  name                    = "gcp-net"  
  auto_create_subnetworks = "false"  
}

# Subnetwork for VPC network
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "gcp-subnet"  
  ip_cidr_range = "10.0.0.0/16"  
  region        = "us-central1"  
  network       = google_compute_network.vpc_net.self_link  
}

# Firewall rule to allow SSH access
resource "google_compute_firewall" "firewall_ssh" {
  name    = "gcp-ssh" 
  network = google_compute_network.vpc_net.self_link  

  allow {
    protocol = "tcp"  
    ports    = ["22"]  
  }

  source_ranges = ["0.0.0.0/0"]  
}

# Firewall rule to allow HTTP access
resource "google_compute_firewall" "firewall_http" {
  name    = "gcp-http"  
  network = google_compute_network.vpc_net.self_link  

  allow {
    protocol = "tcp" 
    ports    = ["80"]  
  }

  source_ranges = ["0.0.0.0/0"] 
}

# Create GCP VM
resource "google_compute_instance" "vm_instance" {
  name         = "gcp-vm"  
  machine_type = "e2-micro"  

  boot_disk {  
    initialize_params {
      image = "ubuntu-minimal-2210-kinetic-amd64-v20230126" 
    }
  }
  
  # Create network interface
  network_interface { 
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link 
    access_config {
    }
  }
}
