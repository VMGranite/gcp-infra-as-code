output "bucket_urls" {
  value = { for env, b in google_storage_bucket.this : env => b.url }
}
