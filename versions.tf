terraform {
  required_version = "~> 1.17.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.10"
    }
  }

  # Bucket and prefix are passed at init time by platform-live (scripts/tf_layer.sh):
  # bucket = stateBucket of the environment, prefix = workload/<project key>. One state per project.
  backend "gcs" {}
}

# Every call runs as planner@ or deployer@ of the team project. The backend is
# not affected by this argument: state access keeps the caller's own identity.
provider "google" {
  project                     = local.project.projectId
  region                      = local.registry.region
  impersonate_service_account = "${var.identity}@${local.project.projectId}.iam.gserviceaccount.com"
}
