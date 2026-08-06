output "bucket_url" {
  description = "gsutil URL of the example bucket."
  value       = google_storage_bucket.example.url
}

output "network_name" {
  description = "Name of the custom VPC network."
  value       = google_compute_network.example.name
}

output "vm_external_ip" {
  description = "Ephemeral external IP of the example VM."
  value       = google_compute_instance.example.network_interface[0].access_config[0].nat_ip
}
