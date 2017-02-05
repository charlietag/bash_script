#!/bin/bash
#cat file_list.txt | while read FILENAME
#do
#    #ls -l html_dev/${FILENAME} html/${FILENAME}
#    diff html_dev/${FILENAME} html/${FILENAME}
#done
DIRA='html'
DIRB='html_dev'
diff -x '*.jpg' -x 'storage' -x '.git' -rq ${DIRA} ${DIRB}
