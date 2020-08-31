pipeline {
    
    options { timestamps() }

    environment { 
        registry = 'javiercaparo/aws-jenkins-pipeline-v4'
		registryCredential = 'dockerhub'
		dockerImage = ''
        CI = 'true'
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

        stage('Build Docker Image tag:latest') {
            when {
                branch 'master'
            }
            steps {
                echo 'buil the image taggin as latest'
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
                        docker build -t $registry:latest .
					'''
				}
            }
        }

        stage('Build Docker Image in Dev branches') {
            when {
                not { branch 'master' }
            }
            steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
                        docker build -t $registry:$BUILD_NUMBER .
					'''
				}
			}
        }

		stage('Push Prod Image To Dockerhub') {
			when {
                branch 'master'
            }
            steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push $registry:latest
					'''
				}
			}
		}

        stage('Push dev Image To Dockerhub') {
			when {
                not { branch 'master' }
            }
            steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push $registry:$BUILD_NUMBER
					'''
				}
			}
		}

		stage('Removing image locally') {
			steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
		}
    }

    post {
        always {
            echo “Pipeline finished”
        }
    }
}