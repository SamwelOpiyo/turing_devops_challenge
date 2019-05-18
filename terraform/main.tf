provider "google" {
  region  = "${var.region}"
  zone    = "${var.zone}"
  project = "${var.project_id}"
}

module "terraform_gcp_gke" {
  source       = "git::https://github.com/SamwelOpiyo/terraform_gcp_gke//?ref=v0.1.0-beta.2"
  region       = "${var.region}"
  zone         = "${var.zone}"
  project_name = "${var.project_name}"
  project_id   = "${var.project_id}"

  cluster_name                  = "${var.cluster_name}"
  cluster_description           = "${var.cluster_description}"
  cluster_zone                  = "${var.cluster_zone}"
  additional_cluster_zone       = "${var.additional_cluster_zone}"
  min_master_version            = "${var.min_master_version}"
  node_version                  = "${var.node_version}"
  cluster_initial_node_count    = "${var.cluster_initial_node_count}"
  node_disk_size_gb             = "${var.node_disk_size_gb}"
  node_disk_type                = "${var.node_disk_type}"
  gke_master_user               = "${var.gke_master_user}"
  gke_master_password           = "${var.gke_master_password}"
  gke_node_machine_type         = "${var.gke_node_machine_type}"
  has_preemptible_nodes         = "${var.has_preemptible_nodes}"
  gke_label_env                 = "${var.gke_label_env}"
  client_email                  = "${var.client_email}"
  service_account_iam_roles     = "${var.cluster_service_account_iam_roles}"
  kubernetes_logging_service    = "${var.kubernetes_logging_service}"
  kubernetes_monitoring_service = "${var.kubernetes_monitoring_service}"
}
