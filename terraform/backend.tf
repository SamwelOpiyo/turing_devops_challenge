terraform {
  backend "gcs" {
    bucket = "cloud-playground-241611"
    prefix = "terraform/state"
  }
}
