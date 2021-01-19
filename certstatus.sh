#!/bin/bash
dstnt=/tmp/domaisOUT-`date -I`.txt

echo ""
echo "         Full path of the domain file looks like '/home/user/domain.txt' "
echo ""
while [[ $valve != 1 ]]
do

  echo ""
     read -p 'Please enter the full path of the file: ' domain_file
  echo ""
  if [ ! -z "$domain_file" ]; then
     valve=1
   else
     echo 'Inputs cannot be blank please try again!'
  fi
done
valve=0

 for domain in $(cat $domain_file); do 
  echo "" >> $dstnt
  echo $domain >>  $dstnt
  curl --insecure -vvI $domain  2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> $dstnt
  echo "done" >> $dstnt
  echo "=======================================" >> $dstnt
  echo "" >> $dstnt;
 done

cat $dstnt
