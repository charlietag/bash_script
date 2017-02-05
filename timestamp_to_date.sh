#!/bin/bash

print_usage() {
        echo "date_timeset.sh [timeset] [timezone] "
        echo "example:date_time.sh 1343729800 CST[PDT]"
        echo ""
}

while getopts "h" Option
do
  case $Option in
    h     ) print_usage
            exit 1;;
    *     ) print_usage
            exit 1;;
  esac
done

ZONE=$2
if [ "${ZONE}" = "CST"  ]
then
        export TZ=Asia/Taipei
elif [ "${ZONE}" = "PDT" ]
then
        export TZ=America/Los_Angeles
elif [ "${ZONE}" = "UTC" ]
then
        export TZ=UTC
fi
date -d "1970-01-01 UTC $1 sec" +"%Y/%m/%d %H:%M:%S %Z"

