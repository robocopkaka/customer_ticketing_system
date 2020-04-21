#!/bin/bash

# shellcheck disable=SC1090
source ~/.bash_profile

# Print deployment info
DEPLOYMENT_TIME=$( date -u "+%Y/%m/%d %H:%M:%S" )
echo "Deployment completed at: $DEPLOYMENT_TIME UTC" > /var/www/customer_ticketing_system/public/deployment.txt

sudo service nginx restart
