
resource "aws_key_pair" "mongo_key_pair" {
  key_name   = "mongo-keypair"
  public_key = file("aws-key.pub")
}

resource "aws_instance" "mongodb_instance" {
  ami           = "ami-0305d0b03812a425e"  # AMI do Ubuntu 20.04 LTS na região US East 1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mongo_key_pair.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "mongodb_instance" > /etc/hostname
              echo "127.0.0.1 mongodb_instance" >> /etc/hosts
              apt-get update
              apt-get install -y mongodb
              sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongodb.conf
              service mongodb restart
              EOF

  tags = {
    Name = "mongodb_instance"
  }
}