pipeline {
    agent {
        docker {
            image 'cirrusci/flutter:stable'
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
        }
    }
}
