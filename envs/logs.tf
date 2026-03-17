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
  display_name       = "events"
  log_type           = "CUSTOM"
  defined_tags       = local.common_defined_tags
}

/************************************************************
Agent Configurations
************************************************************/
resource "oci_logging_unified_agent_configuration" "oracle" {
  compartment_id = oci_identity_compartment.workload.id
  is_enabled     = true
  display_name   = "oracle-linux-configuration"
  description    = "For Oracle Linux Instance"
  group_association {
    group_list = [
      oci_identity_dynamic_group.compute_oracle.id
    ]
  }
  service_configuration {
    ### Configure log inputs
    configuration_type = "LOGGING"
    sources {
      source_type = "LOG_TAIL"
      name        = "nginx"
      paths = [
        "/var/log/nginx/*"
      ]
      parser {
        parser_type               = "NONE"
        message_key               = "message"
        is_estimate_current_event = false
      }
    }
    ### Select log destination
    destination {
      log_object_id = oci_logging_log.oracle.id
      operational_metrics_configuration {
        destination {
          compartment_id = oci_identity_compartment.workload.id
        }
        source {
          type = "UMA_METRICS"
          record_input {
            namespace      = "agent_config_oracle_instance"
            resource_group = "defaultGroup"
          }
          metrics = [
            "Heartbeat",
            "RestartMetric",
            "EmitRecords",
            "BufferSpaceAvailable",
            "SlowFlushCount",
            "RollbackCount",
            "RetryCount"
          ]
        }
      }
    }
  }
  defined_tags = local.common_defined_tags
}

resource "oci_logging_unified_agent_configuration" "windows" {
  compartment_id = oci_identity_compartment.workload.id
  is_enabled     = true
  display_name   = "windows-configuration"
  description    = "For Windows Server Instance"
  group_association {
    group_list = [
      oci_identity_dynamic_group.compute_windows.id
    ]
  }
  service_configuration {
    ### Configure log inputs
    configuration_type = "LOGGING"
    sources {
      source_type = "WINDOWS_EVENT_LOG"
      name        = "security"
      channels = [
        "Security"
      ]
    }
    ### Select log destination
    destination {
      log_object_id = oci_logging_log.windows.id
      operational_metrics_configuration {
        destination {
          compartment_id = oci_identity_compartment.workload.id
        }
        source {
          type = "UMA_METRICS"
          record_input {
            namespace      = "agent_config_windows_instance"
            resource_group = "defaultGroup"
          }
          metrics = [
            "Heartbeat",
            "RestartMetric",
            "EmitRecords",
            "BufferSpaceAvailable",
            "SlowFlushCount",
            "RollbackCount",
            "RetryCount"
          ]
        }
      }
    }
  }
  defined_tags = local.common_defined_tags
}
