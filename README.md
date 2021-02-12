# Certstatus
Bash script that check the status of the SSL certificate from a domain, alerts the time of expiration date and will generate a file with the results.

* Create a file with the list of domains, please omit https:// or http://
* chmod 755 the script certstatus.sh 
* Run the script $./certstatus.sh
* It will ask you for the path of the file that contains the url/domains to be check
* As result will generate a file in /tmp folder by the name of domainsOUT-"an the actual date"
* Enjoy
