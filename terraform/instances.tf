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