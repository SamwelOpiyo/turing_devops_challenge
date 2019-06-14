client_email        = "terraform@cloud-playground-241611.iam.gserviceaccount.com"
cluster_name        = "turing-devops-cluster"
gke_master_password = "turing-devops-cluster-password"
project_id          = "cloud-playground-241611"
project_name        = "cloud-playground"

gke_node_machine_type      = "n1-standard-1"
cluster_initial_node_count = 1
node_locations             = ["europe-west1-b", "europe-west1-c"]

vue_docker_image     = "samwelopiyo/turing_vue:dev.v0.0.1-test"
angular_docker_image = "samwelopiyo/turing_angular:dev.v0.0.1-test"
react_docker_image   = "samwelopiyo/turing_react:dev.v0.0.1-test"



is_http_load_balancing_disabled        = false
is_kubernetes_dashboard_disabled       = false
is_horizontal_pod_autoscaling_disabled = false
is_istio_disabled                      = true
is_cloudrun_disabled                   = true
is_vertical_pod_autoscaling_enabled    = false
is_cluster_autoscaling_enabled         = true
cluster_autoscaling_cpu_max_limit      = 10
cluster_autoscaling_cpu_min_limit      = 1
cluster_autoscaling_memory_max_limit   = 64
cluster_autoscaling_memory_min_limit   = 2
