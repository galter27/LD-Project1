resource "aws_instance" "jenkins-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.private_key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y && sudo apt install fontconfig openjdk-17-jre -y
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y && sudo apt-get install jenkins -y
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ubuntu/jenkins_token.txt
    sudo apt-get update  && sudo apt install docker.io -y && sudo systemctl start docker && sudo systemctl enable docker
    sudo usermod -aG docker jenkins
    sudo systemctl restart jenkins
    EOF

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "Jenkins Server"
  }

  provisioner "remote-exec" {
    inline = [
      # Wait until the Jenkins token file exists
      "while [ ! -f /home/ubuntu/jenkins_token.txt ]; do sleep 5; done",

      # Print the Jenkins token to the Terraform logs
      "echo '#################### JENKINS TOKEN ####################'",
      "cat /home/ubuntu/jenkins_token.txt",
      "echo '#################### JENKINS TOKEN ####################'"

    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_file)
      host        = self.public_ip
    }
  }

}

resource "aws_eip" "jenkins-server-eip" {
  instance = aws_instance.jenkins-server.id
}


resource "aws_ec2_instance_state" "check_running" {
  instance_id = aws_instance.jenkins-server.id
  state = "running"
}