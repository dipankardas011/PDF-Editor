#!/bin/bash
yum install -y git qpdf
cd /home/ec2-user

git clone https://github.com/dipankardas011/PDF-Editor.git
cd PDF-Editor
cp -v pdf-editor.service /etc/systemd/system

systemctl daemon-reload

systemctl start pdf-editor.service

