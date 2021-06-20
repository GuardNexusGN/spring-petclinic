#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker_aws' 
    }
	
    environment {
        APP_PORT = '8080'

        DOCKER_LOGIN = credentials('docker_login')
        DOCKER_PASSWORD = credentials('docker_password')
    }
  
    stages('Tests on worker') {
        stage("Test 1") {
                steps {
                        sh "./mvnw package"
                        sh "java -jar target/*.jar --server.port=${APP_PORT}"
                }
        }
    }
                
    post {
        always {
            archiveArtifacts artifacts: '*.jar', fingerprint: true
        }
    }
}
