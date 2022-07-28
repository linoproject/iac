variable "api_resource_name" {
    type = string
    description = "Enter API resource name"
    default = "lambda-api2"
}

variable "env" {
    type = string
    description = "Enter Environment"
    default = "dev"
    validation {
        condition     = contains(["dev", "prod"], var.env)
        error_message = "Valid values for var: env are (dev, prod)."
    } 
}