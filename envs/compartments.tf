/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "oci-compute-custom-logs"
  description    = "For OCI Compute Custom Logs"
  enable_delete  = true
}