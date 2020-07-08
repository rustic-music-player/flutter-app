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
                sh 'flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi'
                step([$class: 'SignApksBuilder', skipZipalign: true, apksToSign: 'build/app/outputs/apk/release/*-unsigned.apk', keyAlias: 'rustic release key', keyStoreId: 'android-keystore'])
            }

            post {
                always {
                    cleanWs()
                }
            }
        }
    }
}
