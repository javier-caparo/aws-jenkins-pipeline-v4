pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo "Multiline shell steps works too"
                    ls -lah
                '''
            }
        }

        stage('Get AWS IAM user') {
            steps {
                withAWS(region:'us-west-2',credentials:'aws-credentials') {
                    sh 'aws iam get-user'  
                }
            }
        }
     }
}