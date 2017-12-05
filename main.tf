provider "aws" {
region = "us-east-1"
}

variable "server_port" 
{
description = "server usage ports"
default = 80
}

resource "aws_instance" "testserver" {

ami = "ami-55ef662f"
instance_type = "t2.micro"
vpc_security_group_ids = ["${aws_security_group.instance.id}"]
user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              echo "hello world" > /var/www/html/index.html
              service httpd start
              EOF


tags
{
Name = "mytestserver"
}

}

resource "aws_security_group" "instance" {

name = "example-sg"

ingress {

from_port = "${var.server_port}"
to_port  = "${var.server_port}"
protocol  = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = "${var.server_port}"
to_port  = "${var.server_port}"
protocol  = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}


output "public_ip" {
value = "${aws_instance.testserver.public_ip}"
}

