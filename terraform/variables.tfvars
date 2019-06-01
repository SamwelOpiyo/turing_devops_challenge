client_email        = "terraform@cloud-playground-241611.iam.gserviceaccount.com"
cluster_name        = "turing-devops-cluster"
gke_master_password = "turing-devops-cluster-password"
project_id          = "cloud-playground-241611"
project_name        = "cloud-playground"

gke_node_machine_type      = "n1-standard-1"
cluster_initial_node_count = 2
node_locations             = ["europe-west1-b", "europe-west1-c"]

vue_docker_image     = "samwelopiyo/turing_vue:dev.v0.0.1-test"
angular_docker_image = "samwelopiyo/turing_angular:dev.v0.0.1-test"
react_docker_image   = "samwelopiyo/turing_react:dev.v0.0.1-test"
