pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "${env.AWS_ACCOUNT_ID}"
        AWS_DEFAULT_REGION = "${env.REGION}"
        NAME = "${env.NAME}"
        IMAGE_REPO_NAME = "demo-app"
        IMAGE_TAG = "ver${env.BUILD_NUMBER}"
        REPOSITORY_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages {
        stage("Clean Up"){
            steps {
                deleteDir()
            }
        }
        stage('Set AWS_ACCOUNT_ID') {
        steps {
            script {
                echo "MY_VARIABLE: ${AWS_ACCOUNT_ID}, ${AWS_DEFAULT_REGION}, ${NAME}, ${IMAGE_REPO_NAME}, ${IMAGE_TAG}, ${REPOSITORY_URL}"
            }
        }
    }
        stage("Clone Repo"){
            steps {
                sh "git clone https://github.com/RichyCey/DevOps-FirstDemo.git"
            }
        }
        stage("Build"){
            steps {
                sshagent(credentials : ['jenkins-slave']){
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo git -C /var/www/html pull --rebase --autostash https://github.com/RichyCey/DevOps-FirstDemo.git"
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo chown -R ec2-user:ec2-user /var/www/html"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sshagent(credentials: ['jenkins-slave']) {
                    sh 'ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com "cd /var/www/html && sudo docker build -t demo_app:demo_app_tag ."'
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | sudo docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${}'"
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo dockerImage = docker.build '${IMAGE_REPO_NAME}:${IMAGE_TAG}'"
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_NAME}:$IMAGE_TAG"
                    sh "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Check Website') {
            steps {
                script {
                    sshagent(credentials : ['jenkins-slave']){
                        def curlResult = sh(script: "ssh ec2-user@ec2-34-207-48-198.compute-1.amazonaws.com sudo curl -Is 34.207.48.198:8000 | head -n 1", returnStatus: true)
                        echo "curlResult: ${curlResult}"
                    }
                }
            }
        }
    }
}
