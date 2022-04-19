terraform {
  required_providers {
    
  }
}

provider "docker" {}

resource "docker.image" "pdf-editor:beta" {
  
}

resource "docker_container" "pdf-editor-tool" {
  
}