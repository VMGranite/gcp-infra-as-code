terraform {
  required_version = ">= 1.7.0"
}

output "rendered_message" {
  value = templatefile("${path.module}/templates/welcome.tftpl", {
    name = var.your_name
  })
}
