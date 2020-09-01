pipeline {
    
    options { timestamps() }

    environment { 
        cluster_name = 'Capstone_cluster'
        registry = 'javiercaparo/aws-jenkins-pipeline-v4'
		registryCredential = 'dockerhub'
        ekr_registry = '156823553040.dkr.ecr.us-west-2.amazonaws.com'
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
        stage('Linting') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Basic Information') {
            steps {
                sh "echo tag: ${params.RELEASE_TAG}"
            }
        }

        stage('Build Image to dockerhub') {
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

        stage('Dev branches:Build and deploy to EKR') {
            when {
                not { branch 'master' }
            }
            steps {
				withAWS(credentials: 'aws-credentials', region: 'us-west-2') {
                    echo 'Login first'
                    sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ekr_registry'
                    echo 'Build the image to EKR'
                    sh 'docker build -t eks-webapp:$BUILD_NUMBER .'
                    echo 'Tagging the image'
                    sh 'docker tag eks-webapp:$BUILD_NUMBER $ekr_registry/eks-webapp:$BUILD_NUMBER'
                    echo 'Push the image to EKR repo'
                    sh 'docker push 156823553040.dkr.ecr.us-west-2.amazonaws.com/eks-webapp:$BUILD_NUMBER'
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