pipeline {
    agent {
        dockerfile {
            filename '.jenkins/Dockerfile'
            args '-v /usr/share/jenkins/cache:/build_cache'
        }
    }

    triggers {
        pollSCM('H/30 * * * *')
    }

    environment {
        PUB_CACHE='/build_cache/dart'
    }

    stages {
        stage('Build') {
            steps {
                sh 'flutter build appbundle'
                archiveArtifacts artifacts: 'build/app/outputs/bundle/release/*.aab', fingerprint: true
            }

            post {
                always {
                    cleanWs()
                }
            }
        }
    }
}
