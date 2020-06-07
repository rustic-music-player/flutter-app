pipeline {
    agent {
        docker {
            image 'adamantium/flutter:latest'
            args '-v /usr/share/jenkins/cache:/build_cache'
        }
    }

    environment {
        PUB_CACHE='/build_cache/dart'
    }

    stages {
        stage('Build') {
            steps {
                sh 'flutter build appbundle'
            }

            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/bundle/release/*.aab', fingerprint: true
                }
            }
        }
    }
}
