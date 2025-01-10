resource "google_cloudfunctions_function" "function_http_trigger" {
  count                 = var.trigger_http ? 1 : 0
  project               = var.project
  name                  = var.function_name
  description           = var.description
  region                = var.region
  runtime               = var.runtime
  trigger_http          = var.trigger_http
  available_memory_mb   = var.available_memory_mb
  timeout               = var.timeout
  source_archive_bucket = var.bucket_name
  source_archive_object = var.ziped_code_name
  entry_point           = var.entrypoint
  environment_variables = var.environment_variables
  service_account_email = var.serviceaccount_mail
}

resource "google_cloudfunctions_function" "function_event_trigger" {
  count                 = var.trigger_http ? 0 : 1
  name                  = var.function_name
  description           = var.description
  region                = var.region
  runtime               = var.runtime
  project               = var.project
  service_account_email = var.serviceaccount_mail
  event_trigger {
    event_type = var.event_type
    resource   = var.event_resource
  }
  timeout               = var.timeout
  available_memory_mb   = var.available_memory_mb
  source_archive_bucket = var.bucket_name
  source_archive_object = var.ziped_code_name
  entry_point           = var.entrypoint
  environment_variables = var.environment_variables
}
