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

        stage('Configure with Ansible') {
            steps {
                script {
                    // Run Ansible playbook to configure the Jenkins server
                    // Assuming you have an inventory file in your project with EC2 public IP and private key setup
                    sh '''
                        ansible-playbook -i hosts.ini --private-key=${PRIVATE_KEY_PATH} playbook.yml
                    '''
                }
            }
        }
    }

    //     stage('Run Ansible Configuration') {
    //         steps {
    //             script {
    //                 // Run Ansible playbook to configure EC2 instances
    //                 sh 'ansible-playbook -i ansible/inventory ansible/jenkins_setup.yml'
    //             }
    //         }
    //     }

    //     stage('Cleanup') {
    //         steps {
    //             script {
    //                 // Optional: clean up any resources or files (e.g., Terraform state)
    //                 sh 'terraform state rm aws_instance.example'
    //             }
    //         }
    //     }
    // }

}
