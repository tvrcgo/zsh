
alias dkl="dk logs"

dk() {
 docker $@
}

dls() {
 print $fg[yellow]
 docker images $@
 print $fg[green]
 docker ps $@
}

dla() {
 dls -a
}

drun() {
 docker run -dit --name $1 ${2:-$1}
}

dbash() {
 docker exec -it $(docker ps -aqf "name=$1") bash
}

dsh() {
 docker exec -it $(docker ps -aqf "name=$1") sh
}

drm() {
 if [[ -n $1 ]];then
  docker stop $(docker ps -a | grep "$1" | awk '{ print $1 }')
  docker rm $(docker ps -a | grep "$1" | awk '{ print $1 }')
 fi
}

drmi() {
 if [[ -n $1 ]];then
  docker rmi $(docker images | grep "$1" | awk '{ print $1 ":" $2 }')
 fi
}

drmx() {
 docker rm $(docker ps -qf status=exited)
 docker rmi $(docker images -qf dangling=true)
}

dc() {
 docker-compose $@
}

dcmake() {
 dc build --no-cache $@
}

dcrun() {
 dc up --build -d --force-recreate $@
}

