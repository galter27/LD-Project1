pipeline {
    agent any

    environment {
        // AWS credentials (you can use Jenkins credentials plugin or AWS CLI profile)
        AWS_ACCESS_KEY_ID = credentials('3fe379d5-6189-4715-8047-cb951175fbe4')
        AWS_SECRET_ACCESS_KEY = credentials('3fe379d5-6189-4715-8047-cb951175fbe4')
        AWS_REGION = 'il-central-1' // Change to your desired region
        PRIVATE_KEY_PATH = credentials('90c40cd3-d547-4bd7-af05-b8502aeda3df')
        ANSIBLE_PYTHON_INTERPRETER = '/usr/bin/python3.8'
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
                        // Run Terraform apply
                        sh 'terraform apply -auto-approve'

                        // Retrieve the Elastic IP from the file created by Terraform
                        def elastic_ip = readFile('jenkins-elastic-ip.txt').trim()

                        // Write the hosts.ini file with the fetched Elastic IP and other details
                        writeFile file: '../ansible/hosts.ini', text: """
[jenkins_servers]
${elastic_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${PRIVATE_KEY_PATH}
"""
                        // Optionally print Jenkins URL to the Jenkins logs
                        echo "Jenkins is available at: http://${elastic_ip}:8080"
                    }
                }
            }
        }

        stage('Get private key for ansible') {
            steps {
                withCredentials([file(credentialsId: 'jenkins-ansible-key', variable: 'SSH_KEY_PATH')]) {
                    sh """
                        cp $SSH_KEY_PATH ${WORKSPACE}/ansible/jenkins-ansible-key
                        chmod 600 $WORKSPACE/ansible/jenkins-ansible-key
                    """
                }
            }
        }

        stage('Configure with Ansible') {

            agent {
                docker {
                    dockerfile true
                    args '-v $WORKSPACE:/workspace -w /workspace'
                }
            }

            environment {
                ANSIBLE_LOCAL_TEMP = '/workspace/.ansible/tmp'
                HOME = '/workspace'
            }
            
            steps {
                sh '''
                    mkdir -p /workspace/.ansible/tmp
                    ansible --version
                '''
            }


            // steps {
            //     dir('ansible') {
            //         script {
            //             // Using the credentials for the SSH private key
            //             withCredentials([file(credentialsId: '90c40cd3-d547-4bd7-af05-b8502aeda3df', variable: 'PRIVATE_KEY_PATH')]) {
            //                 sh '''
            //                     ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini --private-key=${PRIVATE_KEY_PATH} playbook.yaml
            //                 '''
            //             }
            //         }
            //     }
            // }
        }
    }
    // post {
    //     failure {
    //         dir('terraform') {
    //             sh 'terraform destroy -auto-approve'
    //         }
    //     }
    // }

}
