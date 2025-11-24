terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pull l'image depuis Docker Hub
resource "docker_image" "cv_image" {
  name         = "achrefs161/cv-onpage:latest"
  keep_locally = false
}

# Créer le conteneur
resource "docker_container" "moncv" {
  name  = "moncv"
  image = docker_image.cv_image.image_id

  ports {
    internal = 80
    external = 8585
  }

  restart = "unless-stopped"
}
