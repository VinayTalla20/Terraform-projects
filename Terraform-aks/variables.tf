variable "client_id" {
    type = string
    description = "client id or azure app id"
}

variable "client_secret" {
    type = string
    description = "client secret of client id"
    sensitive = true
}

variable "tenant_id" {
    type = string
    description = "tenant_id for azure active directory"
}

variable "subscription_id" {
    type = string
    description = "subcription needed to create resources"
}
