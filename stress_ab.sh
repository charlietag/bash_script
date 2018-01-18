#!/bin/bash
for((i=1;;i++)); do
  if [[ $RC -eq 1 ]]; then
    echo "terminated...."
    exit
  fi
  echo "------------------------"
  echo "ab tool round $i"
  echo "------------------------"
  ab -c 100 -t 86400 $1
  RC=$?
  echo
done
