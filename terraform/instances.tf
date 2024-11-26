resource "aws_key_pair" "jenkins_ansible_key" {
  key_name   = "jenkins-ansible-key"
  public_key = file(var.public_key_path)  # Path to your public key

  tags = {
    Name = "Jenkins Ansible SSH Key"
  }
}

resource "aws_instance" "jenkins-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.jenkins_ansible_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  # User Data for installing Python, Jenkins, Docker, etc.
  user_data = <<-EOF
              #!/bin/bash
              # Install Python 3.8 and necessary packages
              sudo apt update
              sudo apt install software-properties-common -y 
              sudo add-apt-repository ppa:deadsnakes/ppa  -y
              sudo apt install python3.8 -y

              EOF

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins Server"
  }

}

resource "aws_eip" "jenkins-server-eip" {
  instance = aws_instance.jenkins-server.id
}


resource "aws_ec2_instance_state" "check_running" {
  instance_id = aws_instance.jenkins-server.id
  state = "running"
}

resource "local_file" "elastic_ip" {
  content  = aws_eip.jenkins-server-eip.public_ip
  filename = "jenkins-elastic-ip.txt"
}