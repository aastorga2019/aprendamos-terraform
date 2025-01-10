output "url" {
  description = "URL de la funcion en caso de ser gatillada por http"
  value       = var.trigger_http ? google_cloudfunctions_function.function_http_trigger[0].https_trigger_url : "Trigger HTTP no está habilitado"
}
