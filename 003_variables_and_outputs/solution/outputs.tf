output "bucket_url" {
  description = "gs:// URL of the bucket."
  value       = google_storage_bucket.my_bucket.url
}

output "bucket_self_link" {
  description = "Self link of the bucket."
  value       = google_storage_bucket.my_bucket.self_link
}
