# GCP GKE outputs for mudule terraform_gcp_gke

output "terraform_gcp_gke_project_name" {
  value = "${module.terraform_gcp_gke.project_name}"
}

output "terraform_gcp_gke_project_id" {
  value = "${module.terraform_gcp_gke.project_id}"
}

output "region" {
  value = "${module.terraform_gcp_gke.region}"
}

output "zone" {
  value = "${module.terraform_gcp_gke.zone}"
}

output "google_container_cluster_cluster_endpoint" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_cluster_endpoint}"
  description = "Endpoint for accessing the master node"
}

output "google_container_cluster_client_certificate" {
  value = "${module.terraform_gcp_gke.google_container_cluster_client_certificate}"
}

output "google_container_cluster_client_key" {
  value = "${module.terraform_gcp_gke.google_container_cluster_client_key}"
}

output "google_container_cluster_cluster_ca_certificate" {
  value = "${module.terraform_gcp_gke.google_container_cluster_cluster_ca_certificate}"
}

output "google_service_account_cluster_service_account_email" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_email}"
}

output "google_service_account_cluster_service_account_unique_id" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_unique_id}"
}

output "google_service_account_cluster_service_account_name" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_name}"
}

output "google_service_account_cluster_service_account_display_name" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_display_name}"
}

output "google_service_account_cluster_service_account_key_name" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_key_name}"
}

output "google_service_account_cluster_service_account_key_public_key" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_key_public_key}"
}

output "google_service_account_cluster_service_account_key_private_key" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_key_private_key}"
}

output "google_service_account_cluster_service_account_key_valid_after" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_key_valid_after}"
}

output "google_service_account_cluster_service_account_key_valid_before" {
  value = "${module.terraform_gcp_gke.google_service_account_cluster_service_account_key_valid_before}"
}

output "google_container_cluster_name" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_name}"
  description = "The name of the cluster, unique within the project and zone."
}

output "google_container_cluster_location" {
  value       = "${module.terraform_gcp_gke.google_container_location}"
  description = "The location that the master and the number of nodes specified in initial_node_count has been created in."
}

output "google_container_cluster_cluster_ipv4_cidr" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_cluster_ipv4_cidr}"
  description = "The IP address range of the kubernetes pods in the cluster."
}

output "google_container_cluster_cluster_autoscaling" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_cluster_autoscaling}"
  description = "Configuration for cluster autoscaling (also called autoprovisioning)."
}

output "google_container_cluster_description" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_description}"
  description = "Description of the cluster."
}

output "google_container_cluster_enable_kubernetes_alpha" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_enable_kubernetes_alpha}"
  description = "Enable Kubernetes Alpha setting. If enabled, the cluster cannot be upgraded and will be automatically deleted after 30 days."
}

output "google_container_cluster_enable_legacy_abac" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_enable_legacy_abac}"
  description = "Whether the ABAC authorizer is enabled for this cluster. When enabled, identities in the system, including service accounts, nodes, and controllers, will have statically granted permissions beyond those provided by the RBAC configuration or IAM."
}

output "google_container_cluster_initial_node_count" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_initial_node_count}"
  description = "The number of nodes created in this cluster's default node pool (not including the Kubernetes master)."
}

output "google_container_cluster_logging_service" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_logging_service}"
  description = "The logging service that the cluster writes logs to."
}

output "google_container_cluster_monitoring_service" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_monitoring_service}"
  description = "The monitoring service that the cluster writes metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting."
}

output "google_container_cluster_master_auth" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_master_auth}"
  description = "The authentication information for accessing the Kubernetes master."
}

output "google_container_cluster_min_master_version" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_min_master_version}"
  description = "The minimum version of the master. GKE will auto-update the master to new versions."
}

output "google_container_cluster_master_version" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_master_version}"
  description = "The version of the master."
}

output "google_container_cluster_network" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_network}"
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected."
}

output "google_container_cluster_network_policy" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_network_policy}"
  description = "Configuration options for the NetworkPolicy feature."
}

output "google_container_cluster_node_config" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_node_config}"
  description = "Configuration options for the nodes."
}

output "google_container_cluster_node_pool" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_node_pool}"
  description = "List of node pools associated with this cluster. Warning: node pools defined inside a cluster can't be changed (or added/removed) after cluster creation without deleting and recreating the entire cluster. Use the google_container_node_pool resource instead of this property during creation."
}

output "google_container_cluster_node_version" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_node_version}"
  description = "The Kubernetes version on the nodes."
}

output "google_container_cluster_project" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_project}"
  description = "The ID of the project in which the resource belongs."
}

output "google_container_cluster_addons_config" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_addons_config}"
  description = "The configurations for addons supported by GKE."
}

output "google_container_cluster_instance_group_urls" {
  value       = "${module.terraform_gcp_gke.google_container_cluster_instance_group_urls}"
  description = "List of instance group URLs which have been assigned to the cluster."
}


# Kubernetes Resources Outputs

output "vue_image" {
  value       = "${kubernetes_deployment.vue-deployment.spec[0].template[0].spec[0].container[0].image}"
  description = "Current Vue Application Deployed."
}

output "angular_image" {
  value       = "${kubernetes_deployment.angular-deployment.spec[0].template[0].spec[0].container[0].image}"
  description = "Current Angular Application Deployed."
}

output "react_image" {
  value       = "${kubernetes_deployment.react-deployment.spec[0].template[0].spec[0].container[0].image}"
  description = "Current React Application Deployed."
}
