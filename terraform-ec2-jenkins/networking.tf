resource "aws_security_group" "allow_all_from_my_ip" {
  name        = "allow_all_from_my_ip"
  description = "Allow all inbound traffic from my IP"

  ingress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.my_ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
