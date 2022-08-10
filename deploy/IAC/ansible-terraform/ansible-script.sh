
# Licensed under the Apache License, Version 2.0 (the "License");
# Author: dipankardas011

sysUpdate() {
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./pdf-terraform.pem -i 'http://34.238.111.206/,' ec2-cfg.yml
}

againDeployNewVersion() {
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./pdf-terraform.pem -i 'http://34.238.111.206/,' ec2-cfg-update.yml
}


if [ $# != 1 ]; then
  echo -n "
Help [1 argument required]
0 system update
1 again deploy
"
  exit 1
fi

choice=$1

if [ $choice -eq 0 ]; then
  sysUpdate
elif [ $choice -eq 1 ]; then
  againDeployNewVersion
else
  echo 'Invalid request'
  return 1
fi

