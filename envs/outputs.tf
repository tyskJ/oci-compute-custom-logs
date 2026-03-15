/************************************************************
Windows PW
************************************************************/
output "windows_pw" {
  value = random_string.instance_password.result
}