# SpacialDB

This is the SpacialDB customer facing application

It will handle:

* Signup/Signin/Accounts
* Management Plans/Subscriptions including: creation, cancellation, upgrades and downgrades
* Provisioning via Digital Ocean


##Running on Linux and OS X

* Make sure you have Redis installed
* Make sure you have Postgres installed and configured so that your role is your username and you can create databases and connect to them with or without a password
* Make sure Postgres is running

* Make sure you have a new ruby installed as well as the `rake` and `bundler` gems installed: `gem install bundler`

* `git clone https://github.com/nomadlabs/spacialdb.git` and `cd spacialdb`

* Edit `spacialdb/config/database.yml` if you need to add your Postgres role's username and password if you need it

* Run `bundle install` to install all the gem dependencies

* Setup the database via `bundle exec rake db:setup` which will create the database, load the schema and initialize it with the seed data

* Run the background tasks via `bundle exec foreman start`

* Run the rails server `bundle exec rails server`
