resource "aws_instance" "app1" {
  ami                    = "ami-0b08bfc6ff7069aff"
  instance_type          = "t2.micro"
  key_name               = "main-key"
  subnet_id              = aws_subnet.pub-sub-2.id
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  tags = {
    Name = "web"
  }
}

resource "aws_instance" "app2" {
  ami                    = "ami-0b08bfc6ff7069aff"
  instance_type          = "t2.micro"
  key_name               = "main-key"
  subnet_id              = aws_subnet.db-pub-sub-1.id
  vpc_security_group_ids = ["${aws_security_group.db-sg.id}"]
  tags = {
    Name = "web-db"
  }
}

