/************************************************************
PW
************************************************************/
resource "random_string" "instance_password" {
  length  = 16
  special = true
}

/************************************************************
Cloud-Init
************************************************************/
data "cloudinit_config" "this" {
  gzip          = false
  base64_encode = true
  part {
    filename     = "windows_init.ps1"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/windows_init.ps1", {
      instance_user     = "opc"
      instance_password = random_string.instance_password.result
    })
  }
}