# tools/datadog/terraform/datadog_monitors.tf
terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }
}
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
variable "datadog_api_key" {
  type      = string
  sensitive = true
}
variable "datadog_app_key" {
  type      = string
  sensitive = true
}
resource "datadog_monitor" "high_cpu_utilization" {
  name    = "[Auto] High CPU Utilization on {{host.name}}"
  type    = "metric alert"
  message = "CPU utilization is over 90% on host {{host.name}}. @pagerduty-critical"
  query   = "avg(last_5m):avg:system.cpu.system{*} by {host} > 90"
  monitor_thresholds {
    critical = 90
    warning  = 75
  }
  tags = ["terraform", "autogen", "cpu"]
}
