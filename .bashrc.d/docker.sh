alias dcb='docker-compose build'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcps='docker-compose ps'
alias dil='docker image list'
alias dps='docker ps'
alias dup='docker-compose up -d'
alias dur='docker-compose up'
alias ddn='docker-compose down'

dosh() {
  if [ $# -eq 0 ]; then
    echo "USAGE: $0 CONTAINER [OPTIONS]" >&2
    return 1
  fi
  local container=$1
  shift
  docker exec "$@" -it "$container" /bin/bash
}

dori() {
  if [ $# -eq 0 ]; then
    echo "USAGE: $0 IMAGE [OPTIONS]" >&2
    return 1
  fi
  local image=$1
  shift
  docker run "$@" -it "$image" /bin/bash
}

doreg() {
  service="$1"
  docker-compose build "$service" || return 1
  docker stop "$service"
  docker-compose up -d "$service"
}
