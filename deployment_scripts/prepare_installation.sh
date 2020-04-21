#!/bin/bash

rm -rf /var/www/prev_customer_ticketing_sytem

mv /var/www/customer_ticketing_sytem /var/www/prev_customer_ticketing_sytem

mkdir /var/www/customer_ticketing_sytem

cd /var/www/customer_ticketing_sytem || exit

sudo chown -R www-data:www-data .

