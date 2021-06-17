resource "google_cloud_run_service" "covid_stats" {
  name     = "covid-stats-foo"
  location = var.google_region

  template {
    spec {
      containers {
        image = "gcr.io/${var.google_project_id}/covid-stats"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_binding" "noauth" {
  location = var.google_region
  project  = var.google_project_id
  service  = "covid-stats"

  role       = "roles/run.invoker"
  members    = ["allUsers"]
  depends_on = [google_cloud_run_service.covid_stats]
}
