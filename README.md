# README

## Prerequisites

* Rails - 6.0.2.1
* Ruby - 2.5.3
* Mysql - 8.0.19
* Install `mailcatcher` with `gem install mailcatcher`

## Installation Steps
* After copying this project onto your system, `cd` into this folder
* Run `rails credentials:edit`
* Add a key  - `db_user` and a value representing your database username
* Add a key - `db_password` and a value representing your database password
* Add a socket value depending on your OS - `/var/run/mysqld/mysqld.sock` for Ubuntu. `/tmp/mysql.sock` for MacOS
* Save your new credentials
* Run  `rails db:create` to create the database
* Run `rails db:migrate` to create all the  necessary tables. 
* Alternatively, you can run `rails schema:load`
* Run `rails db:seed` to seed the database with initial values
* Start the app by running `rails s -p 3001`

## Tests
* Run `rspec` to run all the tests
* Run `open coverage/index.html` to show the coverage report

## Mails
* To view mails, run `mailcatcher` in a terminal
* Then go to `http://localhost:1080` to view mails

## Assumptions
* Stored all the users in one table and made use of Single Table Inheritance
* Made use of a worker to export CSVs so that it can be performed asynchronously
* Mails are sent out to a support agent when a request is assigned to them
* Mails are sent out to admins when a customer creates a request


## Challenges experienced
* Couldn't find a way to send exported CSVs to the React app so sending the files to the support agents emails
* Couldn't handle file attachments when creating support requests.
* Didn't add REGEX for validating phone numbers
* Couldn't find  a way to delete CSVs after they've been sent to support agents
