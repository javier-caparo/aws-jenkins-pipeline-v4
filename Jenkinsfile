pipeline {
    environment {
        dockerRegistry = "javiercaparo/aws-jenkins-pipeline-v4"
        dockerRegistryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any

    tools {nodejs "nodejs" }

    parameters {
        gitParameter name: 'RELEASE_TAG',
        type: 'PT_TAG',
        defaultValue: 'master'
    }

    stages {
        stage('Cloning Git') {
            steps {
                git 'https://github.com/jfcb853/aws-jenkins-pipeline-v4.git'
            }
        }
        stage('Build Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('LInting') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Basic Information') {
            steps {
                sh "echo tag: ${params.RELEASE_TAG}"
            }
        }
    }
}