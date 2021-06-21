#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker' 
    }
	
    environment {
        APP_PORT='8080'

        REGISTRY_DOCKER='guardnexus/petclinic'
        USERNAME_FORDOCKER='guardnexus'
        PASSWORD_FORDOCKER=credentials('guardnexus_docker_password')
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
                       sh 'ansible-playbook devotools/ansible/build_container.yml --extra-vars "app_port=${APP_PORT} registry_docker=${REGISTRY_DOCKER} build_number=${BUILD_NUMBER} workspacej=${WORKSPACE} usernamed=${USERNAME_FORDOCKER} passwordd=${PASSWORD_FORDOCKER} "'
                }
        }
            
        stage('Ansible build and archive container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/deploy_container.yml --extra-vars "app_port=${APP_PORT} workspacej=${WORKSPACE} "'
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
                
    //post {
    //    always {
    //        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    //    }
    //}
}
