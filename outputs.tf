# Output Public IP addresses

output "publicip" {
  value = module.publicip.publicip_address
}
