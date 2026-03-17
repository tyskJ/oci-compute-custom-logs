/************************************************************
Log Group
************************************************************/
resource "oci_logging_log_group" "oracle" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "oracle-instance-log-group"
  defined_tags   = local.common_defined_tags
}

resource "oci_logging_log_group" "windows" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "windows-instance-log-group"
  defined_tags   = local.common_defined_tags
}

/************************************************************
Custom Logs - Compute
************************************************************/
resource "oci_logging_log" "oracle" {
  log_group_id       = oci_logging_log_group.oracle.id
  is_enabled         = true
  retention_duration = 30
  display_name       = "nginx"
  log_type           = "CUSTOM"
  defined_tags       = local.common_defined_tags
}

resource "oci_logging_log" "windows" {
  log_group_id       = oci_logging_log_group.windows.id
  is_enabled         = true
  retention_duration = 30
  display_name       = "nginx"
  log_type           = "CUSTOM"
  defined_tags       = local.common_defined_tags
}