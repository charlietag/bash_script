#!/bin/bash
#----------------------------
# Package required
# RedHat:
#   yum install -y httpd-tools
# Ubuntu:
#   apt-get install -y apache2-utils
#----------------------------
# --- Define var---
EXECTIME_SECOND=86400

# --- Start to stress test ---
URL="${1}"
if [[ -z "${URL}" ]]; then
  echo "URL is not specified..."
  echo "Usage: $(basename $0) http://sample.com/ 50"
  echo
  exit
fi

CONCURRENT_USER="${2}"
if [[ -z "${CONCURRENT_USER}" ]]; then
  CONCURRENT_USER=100
fi

for((i=1;;i++)); do
  echo "-----------------------------------------------------------------------------"
  echo "Concurrent user : ${CONCURRENT_USER}"
  echo "Exec time(s)    : ${EXECTIME_SECOND}"
  echo "Round           : ${i}"
  echo "URL             : ${URL}"
  echo "-----------------------------------------------------------------------------"
  ab -c $CONCURRENT_USER -t $EXECTIME_SECOND $URL
  RC=$?

  #------------------------
  # Exit if RC == 1
  # RC code: 1 ---> Ctrl + c
  #------------------------
  if [[ $RC -eq 1 ]] || [[ $RC -eq 22 ]] ; then
    echo
    echo "terminated...."
    echo
    exit
  fi
  #------------------------

  echo
done
