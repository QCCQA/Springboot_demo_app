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
    }
}
