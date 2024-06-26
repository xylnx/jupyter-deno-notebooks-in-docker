#!/bin/bash

JUJS_PATH=${HOME}/Desktop/jupyter
NOTEBOOKS_PATH="${NOTEBOOKS_PATH:=${HOME}/Desktop/jupyter_notebooks}"

jupy() {
  # Stop running container
  if [[ ${1} == 'stop' ]]; then docker stop jupy; return; fi;

  # Make dir to store notebooks in
  ! [[ -d "${NOTEBOOKS_PATH}" ]] && mkdir -p ${NOTEBOOKS_PATH}

  echo "Your notebooks will be stored in ${NOTEBOOKS_PATH}"

  # Run an existing container
  docker run -it -p 8888:8888 --volume ${NOTEBOOKS_PATH}:/jupyter_notebooks --name jupy --rm jupy:0.1
}

jupy_create() {
  # Change dir to the path of this script
  # That's where the Dockerfile is 
  SCRIPTS_DIR="$(dirname "$(readlink -f "$0")")"
  cd ${SCRIPTS_DIR}
  echo 'creating docker container -> jupy:0.1'
  docker build -t jupy:0.1 .
  exit 0
}

source_env_vars() {
  set -a; source ${1:-".env"}; set +a
}

set_environment() {
  # assign env vars
  ! [[ -z "${JUPY_ENV_NOTEBOOKS_PATH}" ]] && NOTEBOOKS_PATH=${JUPY_ENV_NOTEBOOKS_PATH}
  # override notebooks path if set using an options argument
  ! [[ -z "${NOTEBOOKS_PATH_FROM_OPTS}" ]] && NOTEBOOKS_PATH=${NOTEBOOKS_PATH_FROM_OPTS}
}


usage() {
  echo "$(tput bold)jupy$(tput sgr0) [options]"
  echo
  echo "Runs a docker container with jupyter labs, and a $(tput bold)deno$(tput sgr0) kernel."
  echo "Jupy also creates a directory to store jupyter notebooks on the host machine."      
  echo "Its default path is: ${HOME}/Desktop/jupyter_notebooks/."
  echo "Configure the path using the $(tput bold)-p$(tput sgr0) option. Or set $(tput bold)JUPY_ENV_NOTEBOOKS_PATH$(tput sgr0) in a $(tput bold).env$(tput sgr0) file."
  echo
  echo "$(tput bold)options:$(tput sgr0)"
  echo
  echo "-c            Creates a docker container including jupyter labs, and a deno kernel."
  echo "-p<filePath>  Uses the given path to store notbooks and starts container."
  echo "-h            Shows this help message."
  echo
  echo "$(tput bold)Environment variables:$(tput sgr0)"
  echo "Jupy reads environment variables which can be set in a .env file."
  echo
  echo "JUPY_ENV_NOTEBOOKS_PATH    sets where to store jupyter notebooks" 
}



while getopts p:bh opt 2>/dev/null
do
  case "${opt}" in
    p) NOTEBOOKS_PATH_FROM_OPTS=${OPTARG};;
    c) jupy_create; exit 0;;
    h) usage; exit 0;;
    *) echo "Invalid option param"; usage; exit 1;;
    ?) echo "Invalid option param"; usage; exit 1;;
  esac
done

init() {
  source_env_vars
  set_environment
  jupy
}

init
