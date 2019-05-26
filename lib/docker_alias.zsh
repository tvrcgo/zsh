
dk() {
 docker $@
}

dlg() {
 docker logs
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

dcmd() {
 docker exec -it $(docker ps -qf "name=$1") ${2:-bash}
}

drm() {
 if [[ -n $1 ]];then
  cons=`docker ps -a | grep "$1" | awk '{ print $1 }'`
  docker stop $cons
  docker rm $cons
 fi
}

drmi() {
 if [[ -n $1 ]];then
  docker rmi $(docker images -a | grep "$1" | awk '{ print $3 }')
 fi
}

dc() {
 docker-compose $@
}

dcbu() {
 dc build --no-cache $@
}

dcup() {
 dc up --build -d --force-recreate $@
}

