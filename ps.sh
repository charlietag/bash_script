#!/bin/bash

free -m 
echo ""
ps aux |head -n 1
ps aux |grep -iE "pass|nginx|php"  | grep -v 'grep'  | sort -nrk 4
