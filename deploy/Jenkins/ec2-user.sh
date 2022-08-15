#!/bin/bash

# amazon ec2 instance
sudo yum update -y
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y

sudo yum install docker -y

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user

mkdir jenkins-server
cd jenkins-server/

cat <<EOF > dockerfile
FROM jenkins/jenkins

USER root
RUN apt update -y
RUN apt install -y docker.io

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
EXPOSE 8080/tcp
EXPOSE 50000/tcp
EOF

docker build -t jenkins11 .

docker run --rm -d \
-p 8080:8080 \
-p 50000:50000 \
-v jenkins:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
--name jenkins jenkins11


