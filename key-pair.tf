resource "aws_key_pair" "main_key_pair" {
  key_name   = "main-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "main_key_pair" {
  content = tls_private_key.rsa.private_key_pem
  filename = "main-key.pem"
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "main-key.pem"
  file_permission = "0400"
}

