#!/bin/bash
for((i=1;;i++)); do
  echo "------------------------"
  echo "ab tool round $i"
  echo "------------------------"
  ab -c 100 -t 86400 $1
  RC=$?
  if [[ $RC -eq 1 ]]; then
    echo "terminated...."
    exit
  fi
  echo
done
