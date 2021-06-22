#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker' 
    }
	
    environment {
        APP_PORT='8080'
        VERSION = readMavenPom().getVersion()
        //${BUILD_NUMBER}

        REGISTRY_DOCKER='guardnexus/petclinic'
        USERNAME_FORDOCKER='guardnexus'
        PASSWORD_FORDOCKER=credentials('guardnexus_docker_password')
        
        AWS_KEY_PASS=credentials('aws_access_key')
        AWS_KEY_ACCESS_PASS=credentials('aws_secret_access_key')
        //CREDENTIALS_DOCKER=credentials('dockerhub_guardnexus') // CREDENTIALS_DOCKER_USR + CREDENTIALS_DOCKER_PSW
    }
  
    stages('Do it on worker') {
        stage('Compile and test') {
                steps {
                        echo 'BUILD STARTED'
                        //sh 'sudo ./mvnw package'
                        //sh "java -jar target/*.jar --server.port=$APP_PORT"
                        echo 'BUILD ENDED'
                }
        }
            
        stage('Ansible build and archive container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/build_container.yml --extra-vars "app_port=${APP_PORT} registry_docker=${REGISTRY_DOCKER} build_number=${VERSION} workspacej=${WORKSPACE} usernamed=${USERNAME_FORDOCKER} passwordd=${PASSWORD_FORDOCKER} "'
                }
        }
            
        stage('Ansible deploy container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/deploy_container.yml --extra-vars "access_key=${AWS_KEY_PASS} secret_access_key=${AWS_KEY_ACCESS_PASS} app_port=${APP_PORT} workspacej=${WORKSPACE} "'
                }
        }    
            
            
        //stage('Ansible deploy_container') {
        //        steps {
        //               sh 'ansible-playbook devotools/ansible/deploy_container.yml'
        //        }
        //}
            
            
            
            
            
            
            
            
        /*stage('Build image') {
                steps {
                        script {
                                dockerImage = docker.build $REGISTRY_DOCKER:$BUILD_NUMBER --build-arg app_port=$APP_PORT
                        }
                }
        }
            
        stage('Deploy image') {
                steps {
                        script {
                                docker.withRegistry( '', $CREDENTIALS_DOCKER ) {
                                        dockerImage.push()
                               }
                        }
                }
        }
            
        stage('Remove local docker image') {
                steps {
                        sh "docker rmi $REGISTRY_DOCKER:$BUILD_NUMBER"
                }
        }*/
    }
                
    post {
        always {
            archiveArtifacts artifacts: 'targettemp/*.jar', fingerprint: true
        }
    }
}
