#!/bin/bash
cd  /var/log/apache2
cut -f1 -d" " access_log | sort | uniq -c | egrep '[0-9]{4,5} ' | sort -g -r  >count.now.all
egrep -v "212.219.[138|139|238]" count.now.all | grep -v "127.0.0.1" | grep -v "::1" >count.now
##egrep -v "212.219.[138|139|238]" count.now.all | grep -v " 10.1"  | grep -v "127.0.0.1" | grep -v "::1" >count.now
diff count.now count.then  >count.wurin
if [[ -s count.wurin ]]; then
        cat count.now >>count.wurin
        cp count.now count.then
        ##mail -s "IP Hits count in access_log from wurin" ft9@soas.ac.uk jmoreno@scanbit.net library.systems@soas.ac.uk elararchive@soas.ac.uk<count.wurin
        mail -s "IP Hits count in access_log from wurin" ft9@soas.ac.uk <count.wurin
fi;

## Safe IPs
##
## 209.212.23 United States - New Jersey State Library
