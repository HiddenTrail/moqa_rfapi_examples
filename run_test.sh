#!/bin/bash
set -eo pipefail

DATE=$(date +"%Y-%m-%d_%H-%M")
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
variable_file="./environments/test_env.py"
docker=false
robot_container_name="robotfw_api"
tests_path="."
tests_tag=""
preserve_results=false
log_level="INFO"

cd $SCRIPT_DIR

function shut_down() {
    echo "Removing old container"
    docker-compose down
}

function run_docker() {
  local existing_container=$(docker ps -a | grep ${robot_container_name})
  if [ ! -z "${existing_container}" ] ; then
    shut_down
  fi
  docker-compose up
}

function run_robot() {
  echo "Using environment resource file: ${variable_file}"
  if $docker ; then
    export VARIABLE_FILE=${variable_file}; export LOG_LEVEL=${log_level};
    export OUTPUT_DIR="testresults/${DATE}"; export TESTS_TAG=${tests_tag};
    echo "Running using docker"
    run_docker
  else
    echo "Running using local robot"
    robot --variablefile ${variable_file} --skip skip \
        --pythonpath ${SCRIPT_DIR} ${tests_tag} --loglevel=${log_level} \
        -d testresults/${DATE} -x outputxunit.xml -o TestRun.xml -l TestRun.html -r TestReport.html \
        ${tests_path}
  fi
}

function delete_results() {
  if ! $preserve_results ; then
    echo "Removing testresults folder ${SCRIPT_DIR}/testresults"
    rm -rf testresults
  fi
}

while getopts "dt:pv:l:sh" opt; do
  case ${opt} in
    d )
      docker=true
      ;;
    t )
      tests_tag="--i=${OPTARG}"
      ;;
    p )
      preserve_results=true
      ;;
    v )
      variable_file="$OPTARG"
      ;;
    l )
      log_level="$OPTARG"
      ;;
    s )
      shut_down
      exit 0
      ;;
    \? )
      echo "Invalid Option -${OPTARG}" >&2
      exit 1
      ;;
    : )
      echo "Option ${OPTARG} requires an argument" >&2
      exit 1
      ;;
    h|* )
      echo "Usage:"
      echo "-d    Run with Docker. Default is ${docker}."
      echo "-t    Test tag. Default is empty."
      echo "-p    Preserve testresults from previous runs."
      echo "-v    Variable file. Default is ${variable_file}."
      echo "-l    Log level. Default is ${log_level}."
      echo "-s    Shut down docker containers."
      echo "-h    Help"
      exit 0
      ;;
    esac
done

delete_results
run_robot
