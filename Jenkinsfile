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
        HOME='.'
    }

    stages {
        stage('Build') {
            steps {
                sh 'flutter build apk'
                archiveArtifacts artifacts: 'build/app/outputs/**/*.apk', fingerprint: true
            }

            post {
                always {
                    cleanWs()
                }
            }
        }
    }
}
