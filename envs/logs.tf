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