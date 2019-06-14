provider "google" {
  region  = "${var.region}"
  zone    = "${var.zone}"
  project = "${var.project_id}"
}

provider "kubernetes" {
  host     = "${module.terraform_gcp_gke.google_container_cluster_cluster_endpoint}"
  username = "${var.gke_master_user}"
  password = "${var.gke_master_password}"

  client_certificate     = "${base64decode(module.terraform_gcp_gke.google_container_cluster_client_certificate)}"
  client_key             = "${base64decode(module.terraform_gcp_gke.google_container_cluster_client_key)}"
  cluster_ca_certificate = "${base64decode(module.terraform_gcp_gke.google_container_cluster_cluster_ca_certificate)}"
}

module "terraform_gcp_gke" {
  source       = "git::https://github.com/SamwelOpiyo/terraform_gcp_gke//?ref=v0.1.0-beta.4"
  region       = "${var.region}"
  zone         = "${var.zone}"
  project_name = "${var.project_name}"
  project_id   = "${var.project_id}"

  cluster_name                  = "${var.cluster_name}"
  cluster_description           = "${var.cluster_description}"
  cluster_location              = "${var.cluster_location}"
  node_locations                = "${var.node_locations}"
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

  is_http_load_balancing_disabled        = "${var.is_http_load_balancing_disabled}"
  is_kubernetes_dashboard_disabled       = "${var.is_kubernetes_dashboard_disabled}"
  is_horizontal_pod_autoscaling_disabled = "${var.is_horizontal_pod_autoscaling_disabled}"
  is_istio_disabled                      = "${var.is_istio_disabled}"
  is_cloudrun_disabled                   = "${var.is_cloudrun_disabled}"
  daily_maintenance_start_time           = "${var.daily_maintenance_start_time}"
  is_vertical_pod_autoscaling_enabled    = "${var.is_vertical_pod_autoscaling_enabled}"
  is_cluster_autoscaling_enabled         = "${var.is_cluster_autoscaling_enabled}"
  cluster_autoscaling_cpu_max_limit      = "${var.cluster_autoscaling_cpu_max_limit}"
  cluster_autoscaling_cpu_min_limit      = "${var.cluster_autoscaling_cpu_min_limit}"
  cluster_autoscaling_memory_max_limit   = "${var.cluster_autoscaling_memory_max_limit}"
  cluster_autoscaling_memory_min_limit   = "${var.cluster_autoscaling_memory_min_limit}"
}

resource "null_resource" "install-dependencies" {
  triggers = {
    host = "${md5(module.terraform_gcp_gke.google_container_cluster_cluster_endpoint)}"
  }

  provisioner "local-exec" {
    command = <<EOF

      echo "Checking if Helm is installed."
      if ! [ -x "$(command -v helm)" ]; then
        echo "Helm is not installed. Installing Helm."
        curl -LO https://git.io/get_helm.sh
        chmod 700 get_helm.sh
        ./get_helm.sh
      fi

      echo "Setting Up a Service Account for Tiller"
      kubectl create serviceaccount --namespace kube-system tiller
      kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

      echo "Upgrading and Installing tiller..."
      helm init --service-account tiller --upgrade --wait

      echo "Updating helm repositories"
      helm repo update

      echo "Installing Nginx Ingress"
      helm install --name nginx-ingress --namespace nginx-ingress stable/nginx-ingress --set rbac.create=true --wait

      echo "Installing Cert Manager"
      kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
      helm install --name cert-manager --namespace cert-manager stable/cert-manager --wait

      echo "Creating production cluster issuer."
      kubectl apply -f - <<HERE

      apiVersion: certmanager.k8s.io/v1alpha1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-prod
      spec:
        acme:
          # The ACME server URL
          server: https://acme-v02.api.letsencrypt.org/directory
          # Email address used for ACME registration
          email: info@samwelopiyo.guru
          # Name of a secret used to store the ACME account private key
          privateKeySecretRef:
            name: letsencrypt-prod
          # Enable the HTTP-01 challenge provider
          http01: {}

HERE

      EOF
  }

  depends_on = [
    "module.terraform_gcp_gke",
  ]
}
