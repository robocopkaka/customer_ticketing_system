#!/bin/bash

# shellcheck disable=SC2046
sudo chown -R $(whoami):$(whoami) /var/www/customer_ticketing_system

cd /var/www/customer_ticketing_system || exit

RAILS_ENV=production bundle install

sudo chown -R www-data:www-data .