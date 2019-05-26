terraform {
  backend "gcs" {
    bucket  = "turing-devops-tfstate"
    prefix  = "terraform/state"
    project = "cloud-playground-241611"
  }
}
