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
        sh 'cd src/backend/merger && go build -v . && cd ../../frontend/ && npm install'
      }
    }

    stage('Test') {
      steps {
        sh 'cd src/backend/merger && go test -v . && cd ../../frontend/ && export PORT=8080 && npm run test'
      }
    }
  }
}