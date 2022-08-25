pipeline {
  agent any
  tools {
    // gradle 'gradle'
    'org.jenkinsci.plugins.docker.commons.tools.DockerTool' 'docker-latest'
  }
  stages {
    stage('Git-Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/dipankardas011/PDF-Editor.git'
      }
    }

    stage('Build') {
      steps{
        sh '''
          cd src/backend/merger
          docker build --target test -t hello-backendM .
          cd ../rotator
          docker build --target test -t hello-backendR .
          cd ../../frontend/
          docker build --target test -t hello-frontend .
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''
          echo "Backend testing"
          docker run --rm hello-backendM
          echo "Rotator testing"
          docker run --rm hello-backendR
          echo "Frontend testing"
          docker run --rm hello-frontend
        '''
      }
    }
  }

  post {
    always {
      sh '''
        docker rmi -f hello-backendM
        docker rmi -f hello-backendR
        docker rmi -f hello-frontend
        echo "Done cLEAniNg"
      '''
    }
  }
}
