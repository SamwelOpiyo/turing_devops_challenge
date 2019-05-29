# /bin/bash

echo "Checking if Google Cloud SDK is installed."
if ! [ -x "$(command -v gcloud)" ]; then
  echo "Gcloud is not installed. Installing gcloud."
  curl https://sdk.cloud.google.com | bash
  exec -l $SHELL
fi

echo "Checking if Kubectl Cli is installed."
if ! [ -x "$(command -v kubectl)" ]; then
  echo "Kubectl is not installed. Installing Kubectl."
  gcloud components install kubectl --quiet
fi

echo "Checking if Terraform is installed."
if ! [ -x "$(command -v terraform)" ]; then
  echo "Terraform is not installed. Installing Terraform."
  TERRAFORM_VERSION=0.12.0
  URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

  wget $URL

  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d executables/

  mv executables/terraform /usr/local/bin/terraform

  chmod +x /usr/local/bin/terraform

  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

  rm -rf executables/

fi
