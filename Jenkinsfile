#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker_aws' 
    }
	
    environment {
        APP_PORT = '8080'

        REGISTRY_DOCKER = "guardnexus/petclinic"
        CREDENTIALS-DOCKER = 'dockerhub_guardnexus'
    }
  
    stages('Do it on worker') {
        stage("Compile and test") {
                steps {
                        sh "sudo ./mvnw package"
                        //sh "java -jar target/*.jar --server.port=${APP_PORT}"
                }
        }
            
        stage('Build image') {
                steps {
                        script {
                                dockerImage = docker.build registry + ":$BUILD_NUMBER" --build-arg app_port=${APP_PORT}
                        }
                }
        }
            
        stage('Deploy image') {
                steps {
                        script {
                                docker.withRegistry( '', registryCredential ) {
                                        dockerImage.push()
                               }
                        }
                }
        }
            
        stage('Remove local docker image') {
                steps {
                        sh "docker rmi $registry:$BUILD_NUMBER"
                }
        }
    }
                
    post {
        always {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
    }
}
