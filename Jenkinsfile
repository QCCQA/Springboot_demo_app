pipeline {
    agent any

    tools {
        maven "maven3.9.3"
        jdk "java20"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git branch: 'dev', url:'https://github.com/QCCQA/Springboot_demo_app.git'

                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"

            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.war'
                }
            }
        }
        
        stage('Build docker'){
            steps {
                sh "docker build -t springboot-deploy:${env.BUILD_NUMBER} ."
            }
        }
        
        stage('Deploy docker'){
            steps{
              sh "docker stop springboot-deploy || true && docker rm springboot-deploy || true"
              sh "docker run --name springboot-deploy -d -p 8081:8081 springboot-deploy:${env.BUILD_NUMBER}"
            }
        }
        
        stage('Jmeter Infra'){
            steps{
                sh "docker stop master"
                sh "docker rm master"
                sh "docker stop slave01"
                sh "docker rm slave01"
                sh "docker stop slave02"
                sh "docker rm slave02"
                sh "docker stop slave03"
                sh "docker rm slave03"
                
                sh "docker run -dit --name master behsazanqc/jmmaster /bin/bash"
                sh "docker run -dit --name slave01 behsazanqc/jmslave /bin/bash"
                sh "docker run -dit --name slave02 behsazanqc/jmslave /bin/bash"
                sh "docker run -dit --name slave03 behsazanqc/jmslave /bin/bash"
                sh "docker ps -a"
                // sh "docker inspect --format '{{ .Name }} => {{ .NetworkSettings.IPAddress }}' $(sudo docker ps -a -q)"
                // sh "docker exec -i master sh -c 'cat > /jmeter/apache-jmeter-5.6.2/bin/TestStudents.jmx' < TestStudents.jmx"
                // sh "docker exec -it master /bin/bash"
                sh "docker exec master jmeter -n -t TestStudents.jmx"
            }
        }
        
        Stage("Run API Tests"){
            steps{
                
            }
        }
        
        
    }
}
