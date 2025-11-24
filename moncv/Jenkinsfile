pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        IMAGE_NAME = "achrefs161/cv-onpage"
        SLACK_WEBHOOK = credentials('slack-webhook-url')  // 🔔 Slack Webhook
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📥 Récupération du code depuis GitHub...'
                git branch: 'main', url: 'https://github.com/Achrefs16/cv-onpage.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🔨 Construction de l\'image Docker...'
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '📤 Push vers Docker Hub...'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                echo '🧹 Nettoyage des images locales...'
                sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
                sh "docker rmi ${IMAGE_NAME}:latest || true"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline exécuté avec succès!'
            echo "✨ Image disponible sur Docker Hub:"
            echo "   docker pull ${IMAGE_NAME}:${BUILD_NUMBER}"
            echo "   docker pull ${IMAGE_NAME}:latest"

            // 🔔 Slack notification success
            sh """
                curl -X POST -H 'Content-type: application/json' \
                --data '{"text": "✅ *SUCCESS* – Build réussi pour `${IMAGE_NAME}` (#${BUILD_NUMBER})"}' \
                $SLACK_WEBHOOK
            """
        }

        failure {
            echo '❌ Le pipeline a échoué! Consultez les logs.'

            // 🔔 Slack notification failure
            sh """
                curl -X POST -H 'Content-type: application/json' \
                --data '{"text": "❌ *FAILURE* – Le pipeline `${IMAGE_NAME}` (#${BUILD_NUMBER}) a échoué !"}' \
                $SLACK_WEBHOOK
            """
        }

        always {
            echo '🔍 Build terminé - Nettoyage final'
        }
    }
}
