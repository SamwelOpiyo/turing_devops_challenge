# turing_devops_challenge

A challenge to join https://turing.ly/ as a freelance devops engineer. Services to be deployed are from the following repositories:

| App     | Service                               |
|---      |---                                    |
| React	  | https://github.com/SamwelOpiyo/React  |
| Angular	| https://github.com/SamwelOpiyo/Angular|
| Vue	    | https://github.com/SamwelOpiyo/Vue    |

# Issues faced by Ops Teams that are solved by this setup.
* ***Service discovery:*** Kubernetes used in this project solves this by enabling service discovery and load balancing. Kubernetes gives pods their own IP addresses and a single DNS name for a set of pods, and can load-balance across them. For massive micro-services deployment `istio` can be enabled when provisioning using terraform. This adds more features such as:
  * Secure service-to-service communication in a cluster with strong identity-based authentication and authorization.
  * Automatic metrics, logs, and traces for all traffic within a cluster, including cluster ingress and egress.
  * Fine-grained control of traffic behavior with rich routing rules, retries, failovers, and fault injection.

* ***Self-healing:*** Kubernetes used in this project solves this by restarting containers that fail, replacing and rescheduling containers when nodes die, killing containers that don’t respond to user-defined health check, and at the same time not advertising them to clients until they are ready to serve.

* ***Manual and tedious rollouts and rollbacks:*** Kubernetes used in this project allows for automated and smooth rollouts and rollbacks a factor enabled as a result of using declarative configuration. It rolls out changes to the application or its configuration, while monitoring application health to ensure it doesn’t kill all instances at the same time.

* ***Difficulty/Inability to scale horizontally:*** Kubernetes used in this project allows for horizontal scaling. Scaling applications up and down can be done with a simple command, with a UI, or automatically based on CPU usage. Horizontal scaling is done by adding or removing pod replicas or nodes and node-pools.

* ***Difficulty/Inability to scale vertically:*** Google Kubernetes Engine used in this project allows for vertical pod scaling which can be enabled when creating the cluster using terraform.

* ***Mutability:*** Docker Images offer immutability. Since data is not stored in the cluster(docker containers) but in cloud storage, reconstruction is very easy.

* ***Inability/Difficulty in running multiple applications in one hosting:*** Kubernetes allows for running multi containers in one cluster.

* ***Monitoring and Logging:*** Stackdriver is used in this project. It allows for timely notice of issues in the cluster. A more robust solution which can be done given more time is use EFK for logging and Grafana/Prometheus for monitoring.

* ***Manual and time consuming QA test, delivery and deployment:*** This project is set to have automated Continuous Integration/ Continuous Delivery/Continuous Deployment. Travis CI allows for automated testing and deployment. This project has a unique CI/CD flow that carries out tests when code is pushed to branches. The same is done when release tags are pushed to remote origin plus additional building and deploying the changes to the environment.

# CI/CD flow

## Test

* Installs dependencies and tests the code.

* Code pushed to all remote branches and tags go through this stage.

## Test-Build

* Tests if production build is successful.

* Code pushed to all remote branches and tags go through this stage after successful completion of Test stage.

## Build

* Builds docker image and pushes to docker registry.

* Code pushed to only the following tags, go through this stage after successful completion of Test-build stage:
  * `vX+.X+.X+ or vX+.X+.X+-S+`
  * `dev/vX+.X+.X+ or dev/vX+.X+.X+-S+`
  * `release/vX+.X+.X+ or release/vX+.X+.X+-S+`
  * `prod/vX+.X+.X+ or prod/vX+.X+.X+-S+`

X+ represents one integer or more while S+ represents one alphanumeric character or more

* Docker Images built get their name from the tag ie `/ is replaced with .` for example:

| Tag | Image |
|-----|-------|
| v0.1.0 | v0.1.0 |
| dev/v0.1.0 | dev.v0.1.0 |
| dev/v0.1.0-test | dev.v0.1.0-test |

## Deploy

* Creates infrastructure resources if it does not exist and deploys new image.

* Code pushed to only the following tags, go through this stage after successful completion of Test-build stage:
  * `vX+.X+.X+ or vX+.X+.X+-S+`
  * `dev/vX+.X+.X+ or dev/vX+.X+.X+-S+`
  * `release/vX+.X+.X+ or release/vX+.X+.X+-S+`
  * `prod/vX+.X+.X+ or prod/vX+.X+.X+-S+`

X+ represents one integer or more while S+ represents one alphanumeric character or more.

# Infrastructure Setup.

## Dependencies.

* Google Cloud SDK: https://cloud.google.com/sdk/docs/
* Kubectl Cli: https://kubernetes.io/docs/tasks/tools/install-kubectl/
* Terraform:
  * https://learn.hashicorp.com/terraform/getting-started/install.html
  * https://www.terraform.io/downloads.html

To install the three, run:

```
chmod +x install_clis.sh
./install_clis.sh
```

## Environment Variables.

Set the following environment variables. (Replace {project_id} with GCP Project Id.)

```
export TF_CREDS=./service_account_keys/main_service_account.json
export TF_ADMIN="{project_id}"
```

## Infrastructure Creation and Deployment.

### Google Cloud SDK Setup.

Run the following command which will open google login page on a browser. Login using your account credentials to authenticate Google Cloud SDK.

```
gcloud auth application-default login
```

### Project Creation.

Create a project on Google Cloud Platform Console https://console.cloud.google.com/cloud-resource-manager

### Admin Service Account Setup.

Once the project is created, we will create a service account and its key if it does not exist.

```
gcloud iam service-accounts create terraform \
  --display-name "Terraform Admin Account"
```

To check whether the key exists:

```
file service_account_keys/main_service_account.json
```

If the output is `cannot open service_account_keys/main_service_account.json (No such file or directory)`:

```
gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com
```

We will give the service account project editor, Kubernetes Cluster Administrator and I AM Administrator priviledges.

```
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectIamAdmin
```
```
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/editor
```
```
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/container.admin
```

### Configuring the remote bucket.

Create the remote backend bucket in Cloud Storage and the backend.tf file for storage of the terraform.tfstate file:

```
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}
```

```
cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state"
 }
}
EOF
```

We activate the version for this bucket.

```
gsutil versioning set on gs://${TF_ADMIN}
```

We configure the enviroment.

```
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}
```

Once these steps are followed, we initialize the backend.

```
terraform init
```

### Infrastructure Creation.

Edit variables.tfvars appropriately before continuing.

Now we are ready to execute the plan:

```
terraform plan -var-file variables.tfvars
```

and apply:

```
terraform apply -var-file variables.tfvars
```

To get nginx ingress loadbalancer IP that is serving the applications:

```
terraform output nginx-ingress-endpoint
```

If any A records need to be added, they should point to this IP.

### Monitoring and Logging

Monitoring and Logging is set to use monitoring.googleapis.com/kubernetes and logging.googleapis.com/kubernetes respectively.

To view container logs, navigate to https://console.cloud.google.com/kubernetes/workload?project={project_id}, click on the specific deployment and then click on container logs.

To view more verbose monitoring charts/create a dashboard, we will use stackdriver.

Create a stackdriver workspace for monitoring here, https://app.google.stackdriver.com/accounts/create and select the project hosting the cluster(Documentation: https://cloud.google.com/monitoring/workspaces/).

After creating the workspace, navigate to https://app.google.stackdriver.com/kubernetes?project={project_id} to view monitoring updates.

# Cleaning Up.

To destroy everything, you need to perform the following actions.

- Destroy the infrastructure that we have created:

```
terraform destroy -var-file variables.tfvars
```

- Remove the project level permissions of the service acccount:

```
gcloud projects remove-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/editor
```
```
gcloud projects remove-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/container.admin
```
```
gcloud projects remove-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectIamAdmin
```

- Destroy the service acccount:

```
gcloud iam service-accounts delete \
  serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com
```
