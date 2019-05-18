terraform {
  backend "gcs" {
    bucket  = "$(var.backend_bucket_name)"
    prefix  = "terraform/state"
    project = "$(var.backend_project_id)"
  }
}
