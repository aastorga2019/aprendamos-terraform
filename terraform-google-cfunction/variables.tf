variable "project" {
  type        = string
  description = "El proyecto al que se va a desplegar"
}

variable "region" {
  type        = string
  description = "La región donde se van a desplegar los recursos"
}

variable "bucket_name" {
  type        = string
  description = "Bucket para almacenar el código"
}

variable "description" {
  type        = string
  description = "Texto de descripción de la función en la nube"
  default     = "descripcion"
}

variable "available_memory_mb" {
  type        = number
  description = "Memoria asignada a la función"
  default     = 128
}

variable "function_name" {
  type        = string
  description = "El nombre de la función en la nube que se va a crear"
}

variable "runtime" {
  type        = string
  description = "El entorno en el que se ejecuta la función (nodejs10, nodejs12, nodejs14, python37, python38, python39, dotnet3, go113, go116, java11, ruby27)"
}

variable "trigger_http" {
  type        = bool
  description = "Si la función es activada por HTTP, establecer este valor booleano en true"
  default     = true
}

variable "entrypoint" {
  type        = string
  description = "El nombre de la función que se ejecutará en el código"
}

variable "environment_variables" {
  description = "Un mapa de pares clave/valor de variables de entorno para asignar a la función"
  type        = map(string)
  default = {
    KEY = "VALUE"
  }
}

variable "serviceaccount_mail" {
  type        = string
  description = "Cuenta de servicio con la que se ejecutará la función"
}

variable "event_type" {
  description = "If trigger_http is set to false, the event type that will trigger the cloud function"
  type        = string
  default     = ""
}

variable "event_resource" {
  description = "If trigger_http is set to false, the event object which will trigger the function"
  type        = string
  default     = ""
}

variable "timeout" {
  type        = number
  description = "Tiempo máximo de ejecución de la tarea"
  default     = 60
}

variable "ziped_code_name" {
  type        = string
  description = "Nombre del archivo comprimido de la función en el bucket"
}
