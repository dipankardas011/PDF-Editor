pipeline {
  agent {
    // docker { image 'golang:1.18-bullseye' }
    label 'worker'
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
          docker build --target test -t hello-backend .
          cd ../../frontend/
          docker build --target test -t hello-frontend .
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''
          echo "Backend testing"
          docker run --rm hello-backend
          echo "Frontend testing"
          docker run --rm hello-frontend
        '''
      }
    }
  }
  
  post {
    always {
      sh '''
        docker rmi -f hello-backend
        docker rmi -f hello-frontend
        echo "Done cLEAniNg"
      '''
    }
  }
}
