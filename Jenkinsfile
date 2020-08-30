pipeline {
    environment {
        dockerRegistry = "javiercaparo/aws-jenkins-pipeline-v4"
        dockerRegistryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    tools {nodejs "nodejs" }
    stages {
        stage('Cloning Git') {
            steps {
                git 'https://github.com/jfcb853/aws-jenkins-pipeline-v4.git'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run lint'
            }
        }
    }
}