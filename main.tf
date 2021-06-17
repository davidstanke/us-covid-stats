resource "google_cloud_run_service" "covid_stats" {
  name     = "covid-stats"
  location = var.google_region

  template {
    spec {
      containers {
        image = "gcr.io/${var.google_project_id}/covid-stats"
        # env {
        #   name  = "PROJECT_NAME"
        #   value = var.google_project_id
        # }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [
    null_resource.app_container
  ]

}

resource "google_cloud_run_service_iam_binding" "noauth" {
  location = var.google_region
  project  = var.google_project_id
  service  = "covid-stats"

  role       = "roles/run.invoker"
  members    = ["allUsers"]
  depends_on = [google_cloud_run_service.covid_stats]
}
