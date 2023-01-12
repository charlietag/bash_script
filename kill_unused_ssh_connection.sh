netstat -palunt |grep -i est | awk '{print $7}'| cut -d'/' -f1 |xargs -I{} bash -c "ps aux |grep sshd |grep {}|grep -v grep" | head -n -1 | awk '{print $2}' |xargs -I{} kill {}
