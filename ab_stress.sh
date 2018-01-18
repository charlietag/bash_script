#!/bin/bash

#----------------------------
# Package required
# RedHat:
#   yum install -y httpd-tools
# Ubuntu:
#   apt-get install -y apache2-utils
#----------------------------

URL="${1}"
if [[ -z "${URL}" ]]; then
  echo "URL is not specified..."
  echo
  exit
fi

for((i=1;;i++)); do
  echo "-----------------------------------------------------------------------------"
  echo "# Round ${i}"
  echo "${URL}"
  echo "-----------------------------------------------------------------------------"
  ab -c 100 -t 86400 $URL
  RC=$?

  #------------------------
  # Exit if RC == 1
  # RC code: 1 ---> Ctrl + c
  #------------------------
  if [[ $RC -eq 1 ]]; then
    echo
    echo "terminated...."
    echo
    exit
  fi
  #------------------------

  echo
done
