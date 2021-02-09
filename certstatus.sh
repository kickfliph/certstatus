#!/bin/bash
dstnt=/tmp/domaisOUT-`date -I`.txt
days=7

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
  expdatepnt=`echo -n | openssl s_client -connect $domain:443 2>/dev/null | openssl x509 -text 2>/dev/null | sed -ne '/Certificate:/,/Public-Key:/p'`
   
     if [ -z "$expdatepnt" ]; then
       echo "" >> $dstnt
       echo "There is no certificate for the url $domain " >> $dstnt 
       echo "" >> $dstnt
       echo "==============================================================================================" >> $dstnt 
       echo "" >> $dstnt
     else   
        expirationdate=$(date -d "$(: | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null \
                              | openssl x509 -text \
                              | grep 'Not After' \
                              | awk '{print $4,$5,$7}')" '+%s');

            in7days=$(($(date +%s) + (86400*$days)));
 	    if [ $in7days -gt $expirationdate ]; then
	      echo "" >> $dstnt
	      echo "$expdatepnt" >> $dstnt 
	      echo "" >> $dstnt
              echo "WARNING!!! - Certificate for $domain expires in less than $days days, on $(date -d @$expirationdate '+%Y-%m-%d')" >> $dstnt
              echo "" >> $dstnt
              echo "==========================================================================================" >> $dstnt
             else
	       echo "" >> $dstnt	     
	       echo "$expdatepnt" >> $dstnt
	       echo "" >> $dstnt 
               echo "OK - Certificate expires on $(date -d @$expirationdate '+%Y-%m-%d')" >> $dstnt
               echo "" >> $dstnt
               echo "==========================================================================================" >> $dstnt 
           fi
   fi
done

