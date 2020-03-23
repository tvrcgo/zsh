
query_active_containers() {
  # docker ps | grep $1 | awk '{ print $1 }'
  docker ps -qf name=$1
}

query_containers() {
  # docker ps -a | grep $1 | awk '{ print $1 }'
  docker ps -aqf name=$1
}

query_images() {
  # docker images -a | grep $1 | awk '{ print $3 }'
  docker images -aqf reference=*${1}* -f reference=*${1-*}*/* -f reference=*/*${1-*}*
}

remove_none_images() {
  imgs=`docker images --filter "dangling=true" -q --no-trunc`
  if [[ -n $imgs ]]; then
    docker rmi $imgs
  fi
}

dk() {
  docker $@
}

dlg() {
  docker logs $1
}

dls() {
  # images
  print $fg[yellow]
  docker images -af reference=*${1}* -f reference=*${1-*}*/* -f reference=*/*${1-*}*
  # containers
  print $fg[green]
  docker ps -af name=$1
}

drun() {
  docker run -dit --name $1 ${2:-$1}
}

dcmd() {
  docker exec -it $(docker ps -f name=$1 | grep $1 | awk '{ print $1 }') /bin/${2-bash}
}

drm() {
  if [[ -n $1 ]];then
    # stop running containers
    run_cons=`query_active_containers $1`
    if [[ -n $run_cons ]]; then
      docker stop $run_cons
    fi
    # remove containers
    all_cons=`query_containers $1`
    if [[ -n $all_cons ]]; then
      docker rm $all_cons
    else
      echo "No container match."
    fi
  else
    echo "Container name is ?"
  fi
}

drmi() {
  if [[ -n $1 ]];then
    imgs=`query_images $1`
    if [[ -n $imgs ]]; then
      docker rmi $imgs
    else
      echo "No image match."
    fi
  else
    echo "Image name is ?"
  fi
}

dc() {
  docker-compose $@
}

dcbd() {
  docker-compose build --no-cache $@
}

dcup() {
  docker-compose up --build -d $@
}

