resource "aws_security_group_rule" "ingress" {
  provider                 = aws
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.sg.id
  security_group_id        = aws_security_group.db-sg.id
}



