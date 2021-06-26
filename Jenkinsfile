#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker' 
    }
	
    environment {
        APP_PORT='8080'
        QA_PORT='8081'
        INPUT_VERSION=''
        VERSION = readMavenPom().getVersion()
        //${BUILD_NUMBER}

        REGISTRY_DOCKER='guardnexus/petclinic'
        USERNAME_FORDOCKER='guardnexus'
        PASSWORD_FORDOCKER=credentials('guardnexus_docker_password')
        
        AWS_KEY_PASS=credentials('access_key')
        AWS_KEY_ACCESS_PASS=credentials('secret_access_key')
        //CREDENTIALS_DOCKER=credentials('dockerhub_guardnexus') // CREDENTIALS_DOCKER_USR + CREDENTIALS_DOCKER_PSW
    }
  
    stages('Do it on worker') {
        stage('Compile and test') {
                steps {
                        echo sh(script: 'env|sort', returnStdout: true)
                        
                        echo 'BUILD STARTED'
                        sh 'sudo ./mvnw package'
                        //sh 'java -jar target/*.jar --server.port=$APP_PORT'
                        echo 'BUILD ENDED'
                }
        }
        
        stage('Ansible build and archive container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/trigger_roles_container.yml --extra-vars "app_port=${APP_PORT} registry_docker=${REGISTRY_DOCKER} build_number=${VERSION} workspacej=${WORKSPACE} usernamed=${USERNAME_FORDOCKER} passwordd=${PASSWORD_FORDOCKER} access_key=${AWS_KEY_PASS} secret_access_key=${AWS_KEY_ACCESS_PASS}"'
                }
        }
            
        /*stage('Ansible build and archive container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/build_container.yml --extra-vars "app_port=${APP_PORT} registry_docker=${REGISTRY_DOCKER} build_number=${VERSION} workspacej=${WORKSPACE} usernamed=${USERNAME_FORDOCKER} passwordd=${PASSWORD_FORDOCKER} "'
                }
        }
            
        stage('Ansible deploy container') {
                steps {
                       sh 'ansible-playbook devotools/ansible/deploy_container.yml --extra-vars "access_key=${AWS_KEY_PASS} secret_access_key=${AWS_KEY_ACCESS_PASS} app_port=${APP_PORT} workspacej=${WORKSPACE} "'
                }
        }*/
            
        stage('Test env version') {
                steps {
                        script {
                                try {
                                        timeout(time: 180, unit: 'SECONDS') {
                                                def user_input = input(
                                                id: 'userInput', message: 'Run QA ENV (enter none or version):', 
                                                parameters: [
                                                [$class: 'TextParameterDefinition', defaultValue: 'none', description: 'Docker image version', name: 'versiond'],
                                                ])

                                                if ("${user_input}" == "none") {
                                                        try {
                                                                sh ('docker stop qa_app')
                                                        } catch (Exception e) {
                                                                echo ('No qa docker container on background') 
                                                        }

                                                        echo ("No qa env selected, continuing...")        
                                                } else if ("${user_input}" == "latest") { 
                                                        sh ('docker login --username ${USERNAME_FORDOCKER} --password ${PASSWORD_FORDOCKER} docker.io')

                                                        try {
                                                                sh ('docker run --name qa_app -d -p ${QA_PORT}:${APP_PORT}/tcp ${REGISTRY_DOCKER}:${VERSION}')
                                                        } catch (Exception e) {
                                                                sh ('docker stop qa_app')
                                                                sh ('docker rm qa_app')
                                                                sh ('docker run -d --name qa_app -p ${QA_PORT}:${APP_PORT}/tcp ${REGISTRY_DOCKER}:${VERSION}')
                                                        }
                                                }
                                                else {
                                                        INPUT_VERSION = "${user_input}"
                                                        echo ('Selected version: ${INPUT_VERSION}')
                                                        
                                                        sh ('docker login --username ${USERNAME_FORDOCKER} --password ${PASSWORD_FORDOCKER} docker.io')

                                                        try {
                                                                sh ('docker run -d --name qa_app -p ${QA_PORT}:${APP_PORT}/tcp ${REGISTRY_DOCKER}:${INPUT_VERSION}')
                                                        } catch (Exception e) {
                                                                sh ('docker stop qa_app')
                                                                sh ('docker rm qa_app')
                                                                sh ('docker run -d --name qa_app -p ${QA_PORT}:${APP_PORT}/tcp ${REGISTRY_DOCKER}:${INPUT_VERSION}')
                                                        }
                                                }
                                        }
                                } catch(err) {
                                        //def user = err.getCauses()[0].getUser()
                                        
                                        //if('SYSTEM' == user.toString()) {
                                                echo 'Input timeout'
                                        //} else {
                                        //        echo "Aborted by: [${user}]"
                                        //}
                                }
                        }
                }
        }

        /*agent {
                docker {
                    image 'maven:3.8.1-adoptopenjdk-11'
                    args '-v $HOME/.m2:/root/.m2'
                }
        }
            
        stages {
                stage('Build') {
                    steps {
                        sh 'mvn -B'
                    }
                }
        }*/
               
            
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
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                cleanWs()
        }
    }
}
