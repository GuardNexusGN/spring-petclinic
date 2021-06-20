#!/usr/bin/env groovy
pipeline {
    agent { 
        label 'worker_aws' 
    }
	
    environment {
        DOCKER_LOGIN = credentials('docker_login')
        DOCKER_PASSWORD = credentials('docker_password')
    }
  
    stages('Tests on worker') {
        stage("Test 1") {
                steps {
                        sh "./mvnw package"
                        sh "java -jar target/*.jar --server.port=8080"
                }
        }
    }
                
    post {
        always {
            archiveArtifacts artifacts: '*.jar', fingerprint: true
        }
    }
}
