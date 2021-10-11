#!/bin/bash
# -----------------------------------------------------------------------------------------
# Setup config
# -----------------------------------------------------------------------------------------
CURRENT_PATH="$(dirname $0)"
THIS_NAME="$(basename $0)"
CONFIG_FILES="$(ls ${CURRENT_PATH} | grep "\.cfg$" | grep -v "${THIS_NAME}")"

usage() {
  echo "
    $0 -c [ filename ]  ,   read specified config file and ssh to login (*.cfg)
    $0 -l               ,   list config files
    $0 -h               ,   show help
  "
}

show_sample() {
  echo "
    $ cat config_sample.cfg
    REMOTE_USER: user
    REMOTE_HOST: remote.com
    REMOTE_PORT: 2222
  "
}

list_config() {
  if [[ -n "${CONFIG_FILES}" ]]; then
    echo -e "
      Detected config files under '${CURRENT_PATH}':
      ${CONFIG_FILES}
    "
  else
    echo "No config files under '${CURRENT_PATH}'"
  fi
}

ssh_sample() {
  if [[ -n "${CONFIG_FILES}" ]]; then
    echo "Try to connect to remote using the following commands:"
    echo ""

    for config_file in ${CONFIG_FILES[@]}; do
      echo "$0 -c ${config_file}"
    done
  fi
}

while getopts "lc:h?" argv
do
  case $argv in
    c)
      INPUT_FILE=$OPTARG
      CONFIG_FILE_EXISTS="$(echo "${INPUT_FILE}" | grep "\.cfg$" )"
      CONFIG_FILE="${CURRENT_PATH}/${INPUT_FILE}"
      ;;
    l)
      LIST_CONFIG="Y"
      ;;
    h|?)
      usage
      show_sample
      list_config
      ssh_sample
      exit
      ;;
  esac
done

# -----------------------------------------------------------------------------------------
# List config files
# -----------------------------------------------------------------------------------------
if [[ -n "${LIST_CONFIG}" ]]; then
  list_config
  ssh_sample
  exit
fi

# -----------------------------------------------------------------------------------------
# Check if config file exits
# -----------------------------------------------------------------------------------------
if [[ ! -f "${CONFIG_FILE}" ]] && [[ ! -n "${CONFIG_FILE_EXISTS}" ]]; then
  usage
  show_sample
  list_config
  ssh_sample
  exit
fi

# -----------------------------------------------------------------------------------------
# Check config file
# -----------------------------------------------------------------------------------------
CONFIG_CONTENT="$(cat ${CONFIG_FILE} | sed 's/ //g')"
REMOTE_USER="$(echo -e "${CONFIG_CONTENT}" | grep REMOTE_USER | cut -d':' -f2 | grep -Eo "[[:print:]]+" | head -n 1)"
REMOTE_HOST="$(echo -e "${CONFIG_CONTENT}" | grep REMOTE_HOST | cut -d':' -f2 | grep -Eo "[[:print:]]+" | head -n 1)"
REMOTE_PORT="$(echo -e "${CONFIG_CONTENT}" | grep REMOTE_PORT | cut -d':' -f2 | grep -Eo "[[:digit:]]+" | head -n 1)"

if [[ -z "${REMOTE_USER}" ]] || [[ -z "${REMOTE_HOST}" ]] || [[ -z "${REMOTE_PORT}" ]]; then
  show_sample
  exit
fi

# -----------------------------------------------------------------------------------------
# SSH TO REMOTE SERVER
# -----------------------------------------------------------------------------------------
SSH_KEEP_ALIVE=30
echo "ssh -o ServerAliveInterval=${SSH_KEEP_ALIVE} ${REMOTE_USER}@${REMOTE_HOST} -p ${REMOTE_PORT}"
ssh -o ServerAliveInterval=${SSH_KEEP_ALIVE} ${REMOTE_USER}@${REMOTE_HOST} -p ${REMOTE_PORT}
