#!/bin/bash

JUJS_PATH=${HOME}/Desktop/jupyter
NOTEBOOKS_PATH=${HOME}/Desktop/jupyte/notebooks

jupy() {

  # Stop running container
  if [[ ${1} == 'stop' ]]; then docker stop jupy; return; fi;

  # Make dir to store notebooks in
  ! [[ -d "${NOTEBOOKS_PATH}" ]] && mkdir -p ${NOTEBOOKS_PATH}

  # Run an existing container
  docker run -it -p 3456:3456 --volume ${NOTEBOOKS_PATH}:/jupyter_notebooks --name jupy --rm jupy:0.1
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

while getopts p:c opt 2>/dev/null
do
  case "${opt}" in
    p) NOTEBOOKS_PATH=${OPTARG};;
    c) jupy_create;;
    ?) echo "invalid option param"
  esac
done

jupy
