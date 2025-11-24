pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials' // Your Docker Hub credential ID
        IMAGE_NAME = "achrefs161/cv-onpage"
    }

    triggers {
        pollSCM('H/5 * * * *')  // Scrute GitHub toutes les 5 minutes
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
              timeout(time: 30, unit: 'MINUTES') {
                  script {
                      docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                          docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                          docker.image("${IMAGE_NAME}:latest").push()
                      }
                  }
              }
          }
      }

        stage('Clean Up') {
            steps {
                echo '🧹 Nettoyage des images locales...'
                script {
                    sh "docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
                    sh "docker rmi ${IMAGE_NAME}:latest || true"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline exécuté avec succès!'
            echo "✨ Image disponible sur Docker Hub:"
            echo "   docker pull ${IMAGE_NAME}:${BUILD_NUMBER}"
            echo "   docker pull ${IMAGE_NAME}:latest"
        }
        failure {
            echo '❌ Le pipeline a échoué! Consultez les logs.'
        }
        always {
            echo '🔍 Build terminé - Nettoyage final'
        }
    }
}
