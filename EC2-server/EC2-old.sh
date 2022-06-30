#!/bin/bash
sudo apt update -y && sudo apt install git golang-go qpdf -y
echo "Done"
git clone https://github.com/dipankardas011/PDF-Editor.git
cd PDF-Editor/backEnd/
go build
./backend

EOF