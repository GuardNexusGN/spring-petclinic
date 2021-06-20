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
				sh "ansible --version"
				sh "docker version"
				sh "java -version"
				sh "echo \"LOL\" >> main_log.log"
			}
		}
    }
}
