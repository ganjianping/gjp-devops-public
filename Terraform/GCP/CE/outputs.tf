output "instance_id" {
  description = "The server-assigned unique ID of the instance"
  value       = google_compute_instance.instance.id
}

output "instance_name" {
  description = "The name of the instance"
  value       = google_compute_instance.instance.name
}

output "instance_self_link" {
  description = "The URI of the created resource"
  value       = google_compute_instance.instance.self_link
}

output "internal_ip" {
  description = "The internal IP address of the instance"
  value       = google_compute_instance.instance.network_interface[0].network_ip
}

output "external_ip" {
  description = "The external IP address of the instance"
  value       = try(google_compute_instance.instance.network_interface[0].access_config[0].nat_ip, "")
}
