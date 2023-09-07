pipeline {
    agent any
    stages {
        stage("Clean Up"){
            steps {
                deleteDir()
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
