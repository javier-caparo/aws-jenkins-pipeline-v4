pipeline {
    
    options { timestamps() }

    environment { 
        cluster_name = 'Capstone_cluster'
        registry = 'javiercaparo/aws-jenkins-pipeline-v4'
		registryCredential = 'dockerhub'
        ekr_registry = '156823553040.dkr.ecr.us-west-2.amazonaws.com'
		dockerImage = ''
        region = 'us-west-2'
        s3_bucket = 's3://jc-eks-cloudformation'
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

        stage('Lint') {
            steps {
                sh 'hadolint Dockerfile'
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
                echo 'build the image tagging as latest'
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

        stage('Get the cluster kube config') {
			when {
                branch 'master'
            }
            steps {
				withAWS(credentials: 'aws-credentials', region: 'us-west-2') {
					sh '''
						aws eks --region $region update-kubeconfig --name $cluster_name
						ls ~/.kube/config
                        cat ~/.kube/config
					'''
				}	
			}
		}

        stage('kubectl get svc') {
			when {
                branch 'master'
            }
            steps {
				withAWS(credentials: 'aws-credentials', region: 'us-west-2') {
					sh '''
						kubectl get svc
					'''
				}	
			}
		}

        stage('Getting the k8s files') {
			when {
                branch 'master'
            }
            steps {
				withAWS(credentials: 'aws-credentials', region: 'us-west-2') {
					sh '''
						aws s3 cp $s3_bucket/deployment.yaml deployment.yaml
                        aws s3 cp $s3_bucket/service.yaml service.yaml
						ls
					'''
				}	
			}
		}



		stage('Removing image locally') {
			when {
                branch 'master'
            }
            steps{
                sh "docker rmi $registry:latest"
            }
		}
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}