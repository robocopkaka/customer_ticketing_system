#!/bin/bash

# shellcheck disable=SC1090
source ~/.bash_profile

cd /var/www/customer_ticketing_system || exit

RAILS_ENV=production bundle exec rails db:migrate

