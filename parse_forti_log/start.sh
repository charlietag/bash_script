#!/bin/bash

if [[ ! -f "lib_process.sh" ]]; then
  echo "Library(lib_process.sh) file is missing !"
  exit
fi

show_usage() {
  echo ""
  echo "Usage:"
  echo "        ./start.sh -f {log_file_name} -n {file_split_num}"
  echo "Example:"
  echo "        ./start.sh -f ForwardTrafficLog-disk-2021-12-15T13_22_42.182756.log -n 800"
  echo ""
  exit
}


while getopts "f:n:?" argv
do
  case $argv in
    f)
      FILENAME=$OPTARG
      ;;
    n)
      SPLIT_NUM=$OPTARG
      ;;
    ?)
      show_usage
      ;;
  esac
done

# FILENAME="ForwardTrafficLog-disk-2021-12-15T13_22_42.182756.log"
if [[ -z "${FILENAME}" ]] ; then
  echo "ERR: No Forti ForwardTrafficLog filename defined !"
  show_usage
fi

if [[ ! -f "${FILENAME}" ]] ; then
  echo "ERR: No Forti ForwardTrafficLog filename found!"
  show_usage
fi

if [[ ! ${FILENAME} =~ ^ForwardTrafficLog-disk-[\w\.-]+\.log$ ]] ; then
  echo "WARN: Check filename !"
  echo "Example: ForwardTrafficLog-disk-2021-12-15T13_22_42.182756.log"
  show_usage
fi

if [[ -n "${SPLIT_NUM}" ]]; then
  SPLIT_NUM=100
fi

SPLIT_PREFIX="split_"

OUT_CSV="out.csv"
OUT_CSV_TMP="${OUT_CSV}_tmp"

split -l ${SPLIT_NUM} ${FILENAME} ${SPLIT_PREFIX}

ls split_* | xargs -n 1 -P $SPLIT_NUM ./lib_process.sh

cat $OUT_CSV_TMP  | sort -k1,2 > $OUT_CSV

set -x
rm -f ${SPLIT_PREFIX}*
rm -f $OUT_CSV_TMP
