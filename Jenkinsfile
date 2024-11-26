pipeline {
    agent any

    environment {
        // AWS credentials (you can use Jenkins credentials plugin or AWS CLI profile)
        AWS_ACCESS_KEY_ID = credentials('3fe379d5-6189-4715-8047-cb951175fbe4')
        AWS_SECRET_ACCESS_KEY = credentials('3fe379d5-6189-4715-8047-cb951175fbe4')
        AWS_REGION = 'il-central-1' // Change to your desired region
    }

    stages {

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    script {
                    // Run Terraform apply and retrieve the Elastic IP from Terraform output
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                    
                    // Retrieve the Elastic IP from the terraform output
                    def elastic_ip = sh(script: 'terraform output -raw elastic_ip', returnStdout: true).trim()

                    // Write the hosts.ini file with the fetched Elastic IP
                    writeFile file: 'ansible/hosts.ini', text: """
                    [jenkins_servers]
                    ${elastic_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}
                    """
                    }
                }
            }
        }

        stage('Configure with Ansible') {
            steps {
                dir('ansible') {
                    script {
                        withCredentials([file(credentialsId: '	90c40cd3-d547-4bd7-af05-b8502aeda3df', variable: 'PRIVATE_KEY_PATH')]) {
                            sh '''
                                ansible-playbook -i hosts.ini --private-key=${PRIVATE_KEY_PATH} playbook.yaml
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            dir('terraform') {
                sh 'terraform destroy -auto-approve'  // Use this if you want to destroy after the pipeline completes (optional)
            }
        }
    }

    

}
