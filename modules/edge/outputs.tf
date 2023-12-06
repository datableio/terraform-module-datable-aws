output "otel_host" {
  description = "The DNS name of the load balancer"
  value       = try(module.alb.aws_lb.this[0].dns_name, null)
}
