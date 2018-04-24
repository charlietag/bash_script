#!/bin/bash

#----Print Help----
print_help()
{
    echo "$(basename $0)
    -d pem directory
    -w warning days
    -c critical days
    "
}

#----ARGS----
while getopts "hd:w:c:" OPTION
do
    case $OPTION in
        h)
            print_help
            exit 1
            ;;
        d)
            PEM_DIR=$OPTARG
            ;;
        w)
            WARN_DAYS=$OPTARG
            ;;
        c)
            CRITICAL_DAYS=$OPTARG
            ;;
        ?)
            print_help
            exit
            ;;
    esac
done
if [ -z "$PEM_DIR" ] || [ -z "$WARN_DAYS" ] || [ -z "$CRITICAL_DAYS" ]
then
    print_help
    exit
fi

#----Verify CERT Function----
CURRENT_TIME="$(date +"%s")"
EXP_DAYS=""
EXP_MSG=""
expiration_days()
{
    local CERT_FILE=$1
    local CERT_END_DATE="$(openssl x509 -in "${CERT_FILE}" -enddate -noout|sed -e "s/.*=//")"
    local CERT_TIME="$(date -d "${CERT_END_DATE}" +"%s")"
    EXP_DAYS=$((($CERT_TIME - $CURRENT_TIME)/86400))
    EXP_MSG="$(basename ${CERT_FILE}): ${EXP_DAYS} days left($(openssl x509 -in "${CERT_FILE}" -subject -noout | sed -e "s/^.*\/CN=//" -e "s/\/[A-Za-z][A-Za-z]*=.*\$//"|awk -F' |\.' '{print $NF"."$(NF-1)}'))"
}

#----MAIN----
ERR_WARN=""
ERR_CRITICAL=""
ERR_UNKNOWN=""
ERR_MSG=""



PEM_FILES="$(ls ${PEM_DIR})"
for PEM_FILE in $PEM_FILES
do
    expiration_days ${PEM_DIR}/${PEM_FILE}

    if [ $EXP_DAYS -le $WARN_DAYS ]
    then
        ERR_MSG="${ERR_MSG}\n${EXP_MSG}"
    fi

    if [ $EXP_DAYS -le $CRITICAL_DAYS ]
    then
        ERR_CRITICAL="true"
    elif [ $EXP_DAYS -le $WARN_DAYS ]
    then
        ERR_WARN="true"
    else
        ERR_UNKNOWN="true"
    fi
done
ERR_MSG="$(echo "${ERR_MSG}"|sed 's/^\\n//')"
if [ -z "$ERR_MSG" ]
then
    echo "OK - ${PEM_FILES}"
else
    echo "${ERR_MSG}"
fi

if [ ! -z "$ERR_CRITICAL" ]
then
    exit 2
elif [ ! -z "$ERR_WARN" ]
then
    exit 1
elif [ ! -z "$ERR_CRITICAL" ]
then
    exit 3
fi
