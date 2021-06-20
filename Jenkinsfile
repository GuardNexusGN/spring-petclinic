pipeline {
    agent none
     environment {
        DOCKER_LOGIN = credentials('docker_login')
        DOCKER_PASSWORD = credentials('docker_password')
    }
  
   stage('Test on Windows') {
        agent {
            label 'worker'
        }
     
        steps {
            echo "LOL" >> main_log.log
        }
    }
}
