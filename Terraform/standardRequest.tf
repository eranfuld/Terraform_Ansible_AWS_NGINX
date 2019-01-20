provider "aws" {
  access_key = "XXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXX"
  region     = "eu-west-2"
}

resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-01419b804382064e4"
  instance_type = "t2.micro"
  key_name        = "${aws_key_pair.my-key.key_name}"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
 provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install nginx",
      "sudo service nginx start",
      "sudo chmod 777 -R /usr/share/nginx/html/",
      "aws configure set region eu-west-2 --profile myprofile",
      "aws configure set aws_access_key_id XXXXXXXXXXXXXXXXXX --profile myprofile",
      "aws configure set aws_secret_access_key XXXXXXXXXXXXXXXXXXXXXXX --profile myprofile",
      "aws s3 cp s3://s3-35-177-250-45/index.html /usr/share/nginx/html/ --profile myprofile", 
    ]

connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("id_rsa")}"
  }

  }

}
