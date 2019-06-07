# turing_devops_challenge

A challenge to join https://turing.ly/ as a freelance devops engineer. Services to be deployed are from the following repositories:

| App     | Service                               |
|---      |---                                    |
| React	  | https://github.com/SamwelOpiyo/React  |
| Angular	| https://github.com/SamwelOpiyo/Angular|
| Vue	    | https://github.com/SamwelOpiyo/Vue    |

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
