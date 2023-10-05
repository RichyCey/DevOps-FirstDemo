pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "${env.AWS_ACCOUNT_ID}"
        AWS_DEFAULT_REGION = "${env.REGION}"
        NAME = "${env.NAME}"
        IMAGE_REPO_NAME = "demo-app"
        IMAGE_TAG = "ver${env.BUILD_NUMBER}"
        REPOSITORY_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        T_ACCESS_KEY = "${TERRAFORM_ACCESS_KEY}"
        T_S_ACCESS_KEY = "${TERRAFORM_SECRET_ACCESS_KEY}"
    }
    stages {
        stage("Clean Up") {
            steps {
                deleteDir()
            }
        }
        stage("Clone Repo") {
            steps {
                sh "git clone https://github.com/RichyCey/DevOps-FirstDemo.git"
                sshagent(credentials: ['jenkins-slave']) {
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo git -C /var/www/html pull --rebase --autostash https://github.com/RichyCey/DevOps-FirstDemo.git"
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo chown -R ec2-user:ec2-user /var/www/html"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sshagent(credentials: ['jenkins-slave']) {
                    sh 'ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com "cd /var/www/html && sudo docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."'
                }
            }
        }
        stage('Tag Docker Image') {
            steps {
                sshagent(credentials: ['jenkins-slave']) {
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com 'sudo docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URL}:${IMAGE_TAG}'"
                }
            }
        }
        stage('Authenticate with AWS ECR') {
            steps {
                script {
                    sshagent(credentials: ['jenkins-slave']) {
                        sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | sudo docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${}'"

                    }
                }
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                sshagent(credentials: ['jenkins-slave']) {
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com 'sudo docker push ${REPOSITORY_URL}:${IMAGE_TAG}'"
                }
            }
        }
        stage("Terraform") {
            steps {
                sshagent(credentials: ['jenkins-slave']) {
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com 'cd /var/www/html && sudo echo aws_access_key = '\"${T_ACCESS_KEY}\"' > awsVars.auto.tfvars && sudo echo aws_secret_key = '\"${T_S_ACCESS_KEY}\"' >> awsVars.auto.tfvars'"
                }
            }
        }
        stage('Check Website') {
            steps {
                script {
                    sshagent(credentials: ['jenkins-slave']) {
                        def curlResult = sh(script: "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo curl -Is 34.207.48.198:8000 | head -n 1", returnStatus: true)
                        echo "curlResult: ${curlResult}"
                    }
                }
            }
        }
    }
}
