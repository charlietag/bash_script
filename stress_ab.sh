#!/bin/bash
URL="${1}"
for((i=1;;i++)); do
  echo "------------------------"
  echo "Stress tool (ab) Round  $i on $URL"
  echo "------------------------"
  ab -c 100 -t 86400 $URL
  echo

  RC=$?
  if [[ $RC -eq 1 ]]; then
    echo "terminated...."
    echo
    exit
  fi
done
