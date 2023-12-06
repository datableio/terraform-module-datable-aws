output "otel_host" {
  description = "DNS name of the endpoint for sending OTEL data to Datable"
  value       = try(module.edge.dns_name, null)
}
