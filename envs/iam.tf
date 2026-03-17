/************************************************************
Dynamic Group - Compute
************************************************************/
# 「oci_identity_dynamic_group」を使用する場合はルートコンパートメントのDefaultアイデンティティドメインにしか作成できない
# 「oci_identity_domains_dynamic_resource_group」を使用すれば、指定のアイデンティティドメインに作成可能
resource "oci_identity_dynamic_group" "compute_oracle" {
  compartment_id = var.tenancy_ocid
  name           = "Compute_Dynamic_Group_Oracle"
  description    = "Compute Dynamic Group Oracle"
  matching_rule = format(
    "All {instance.compartment.id = '%s', tag.Compute.CloudAgent.value = 'oracle'}",
    oci_identity_compartment.workload.id
  )
  defined_tags = local.common_defined_tags
}

resource "oci_identity_dynamic_group" "compute_windows" {
  compartment_id = var.tenancy_ocid
  name           = "Compute_Dynamic_Group_Windows"
  description    = "Compute Dynamic Group Windows"
  matching_rule = format(
    "All {instance.compartment.id = '%s', tag.Compute.CloudAgent.value = 'windows'}",
    oci_identity_compartment.workload.id
  )
  defined_tags = local.common_defined_tags
}

/************************************************************
IAM Policy - Compute
************************************************************/
resource "oci_identity_policy" "compute_for_agent_logmoni" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "OCI Compute Policy for CloudAgent Custom Log Monitoring"
  name           = "compute-cloudagent-log-monitoring-policy"
  statements = [
    format("allow dynamic-group %s, %s to use log-content in compartment %s",
      oci_identity_dynamic_group.compute_oracle.name,
      oci_identity_dynamic_group.compute_windows.name,
      oci_identity_compartment.workload.name
    )
  ]
  defined_tags = local.common_defined_tags
}

resource "oci_identity_policy" "compute_for_agent_custommoni" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "OCI Compute Policy for CloudAgent Custom Metrics Monitoring"
  name           = "compute-cloudagent-custom-metrics-monitoring-policy"
  statements = [
    format("allow dynamic-group %s, %s to use metrics in compartment %s",
      oci_identity_dynamic_group.compute_oracle.name,
      oci_identity_dynamic_group.compute_windows.name,
      oci_identity_compartment.workload.name
    )
  ]
  defined_tags = local.common_defined_tags
}
