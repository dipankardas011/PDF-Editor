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

    // stage('Get-Packages') {
      // steps {
        // sh 'apt install qpdf -y'
      // }
    // }

    stage('Build') {
      steps{
        sh '''
          cd src/backend/merger
          docker build --target prod -t hello-backend .
          cd ../../frontend/
          docker build --target prod -t hello-frontend .
        '''
      }
    }

    stage('Test') {
      steps {
        sh '''
          echo "Backend testing"
          cd src/backend/merger
          go mod tidy
          go test -v .
          cd ../../frontend/
          echo "Frontend testing"
          export PORT=8085
          npm install
          npm run test
        '''
      }
    }
  }
}