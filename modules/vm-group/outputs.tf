output "instances" {
  description = "VM name → zone"
  value       = { for k, vm in google_compute_instance.vm : vm.name => vm.zone }
}

output "service_account" {
  description = "Service account of the group"
  value       = google_service_account.group.email
}

output "machine_type" {
  description = "Machine type the size was mapped to"
  value       = local.machine_types[var.size]
}
