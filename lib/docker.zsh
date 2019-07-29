
query_active_containers_by_name() {
  docker ps -qf "name=$1"
}

query_active_containers() {
  docker ps | grep $1 | awk '{ print $1 }'
}

query_containers() {
  docker ps -a | grep $1 | awk '{ print $1 }'
}

query_images() {
  docker images -a | grep $1 | awk '{ print $3 }'
}

dk() {
  docker $@
}

dlg() {
  docker logs $(query_active_containers $1)
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
  docker exec -it $(query_active_containers $1) ${2:-bash}
}

drm() {
  if [[ -n $1 ]];then
    docker stop $(query_containers $1)
    docker rm $(query_containers $1)
  fi
}

drmi() {
  if [[ -n $1 ]];then
    docker rmi $(query_images $1)
  fi
}

dc() {
  docker-compose $@
}

dcbu() {
  docker-compose build --no-cache $@
}

dcup() {
  docker-compose up --build -d --force-recreate $@
}

