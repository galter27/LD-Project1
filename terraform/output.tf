output "jenkins_elastic_ip" {
  description = "Elastic IP address of the Jenkins server"
  value       = aws_eip.jenkins-server-eip.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${aws_eip.jenkins-server-eip.public_ip}:8080"
}
