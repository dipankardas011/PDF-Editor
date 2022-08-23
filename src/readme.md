# Faster development

```sh
cd PDF-Editor/src

docker-compose build --no-cache && docker-compose up -d
```

then go to the
[Click Here](http://localhost/)


[Clean up the docker cache](https://forums.docker.com/t/how-to-delete-cache/5753)

```sh

alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'

##### OR

docker kill $(docker ps -q)
docker_clean_ps
docker rmi $(docker images -a -q)
```