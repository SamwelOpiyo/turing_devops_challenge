/*
A "backend" in Terraform determines how state is loaded and how an operation such as apply is executed.
This abstraction enables non-local file state storage, remote execution, etc.

Here are some of the benefits of backends:

    Working in a team:
    Backends can store their state remotely and protect that state with locks to prevent corruption.
    Some backends such as Terraform Enterprise even automatically store a history of all state revisions.

    Keeping sensitive information off disk:
    State is retrieved from backends on demand and only stored in memory.
    If you're using a backend such as Google Cloud Storage, the only location the state ever is persisted is in Google Cloud Storage.

    Remote operations:
    For larger infrastructures or certain changes, terraform apply can take a long, long time.
    Some backends support remote operations which enable the operation to execute remotely.
    You can then turn off your computer and your operation will still complete.
    Paired with remote state storage and locking above, this also helps in team environments.


This terraform script sets the backend to Google Cloud Storage backend.
*/


terraform {
  backend "gcs" {
    bucket = "cloud-playground-241611"
    prefix = "terraform/state"
  }
}
