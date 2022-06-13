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
        sh 'cd backEnd/ && go build -v ./...'
      }
    }

    stage('Test') {
      steps {
        sh 'cd backEnd/ && go test -v ./...'
      }
    }
  }
}