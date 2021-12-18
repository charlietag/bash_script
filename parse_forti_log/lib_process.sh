#!/bin/bash

FILENAME="$1"

OUT_CSV="out.csv"
OUT_CSV_TMP="${OUT_CSV}_tmp"

# echo "YY:  $FILENAME"
cat ${FILENAME} | while read line; do
# tail ${FILENAME} | while read line; do
  DATETIME="$(echo ${line}  | awk '{print $1 $2}' | sed 's/date=//g' | sed 's/time=/ /g')"

  # DATETIME_CST="$(date -d "${DATETIME} UTC" +"%Y-%m-%d %H:%M:%S")"
  DATETIME_CST="${DATETIME}"

  SRCNAME="$(echo ${line} |grep -Eo 'srcname="[^[:space:]]+"' | sed 's/srcname=//g')"

  DSTIP="$(echo ${line} |grep -Eo 'dstip=[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'| grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')"

  DST_NAME="$(host ${DSTIP} | grep addr | tail -n 1 | awk -F'pointer' '{print $2}')"

  # echo "${DATETIME_CST} ${SRCNAME} : ${DST_NAME}"
  echo "${DATETIME_CST},${SRCNAME},${DSTIP},${DST_NAME}" >> $OUT_CSV_TMP
done
