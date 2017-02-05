#!/bin/bash
function usage(){
echo "$0 -f [filename]"
    }

while getopts "f:h" OPTION
do
     case $OPTION in
         h)
             usage
             exit
             ;;
         f)
             FILENAME=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done
if [ -z $FILENAME ]
then
    usage
    exit
fi

ROUND=0
cat $FILENAME |sed 's/>/>\n/g' |sed 's/<\//\n<\//g'|grep -E '<creator>|<title>' -A1 |while read line
do
    if [ $ROUND -eq 1 ]
    then
        echo -n "${line} - "
    fi

    if [ $ROUND -eq 11 ]
    then
        echo "${line}"
    fi


    if [ "${line}" == '<creator>' ]
    then
        ROUND=0
    elif [ "${line}" == '<title>' ]
    then
        ROUND=10
    else
        ROUND=20
    fi
    ROUND=$(($ROUND+1))
done
