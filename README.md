# README

## Description

Simple coding exercise to download an item catalog from an external source (source of truth).
Articles within the catalog are downloaded on every refresh of the index page, and locally added
or the local copy updated. In addition we allow the visitor to Like an article and these likes
are persisted between catalog refreshes.

## Installation


Requires Rails 7 and dependencies. Tested with:
```
$ node -v
v14.17.0
$ ruby -
ruby 3.0.3p157 (2021-11-24 revision 3fb7d2cadc) [x86_64-darwin19]
$ rails -v
Rails 7.0.4.3
$ postgres --version
postgres (PostgreSQL) 14.7 (Homebrew)
```

Recommend the use of a version manager like[rbenv](https://github.com/rbenv/rbenv_) or [asdf](https://asdf-vm.com/)
Used Rbenv.

### Rbenv

Install rbenv with homebrew

`brew install rbenv ruby-build`

then install ruby 3.0.3

`rbenv install 3.0.3`

### Postgres

Taken from [here](https://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/)

Install postgres with homebrew

`brew install postgresql@14`

Start as service

`$ brew services start postgresql@14`

Confirm it is running

`$ brew services list`

### Project checkout

Once you have checkout out the repository

`cd <project_dir>`

Set the ruby local version:

`project_dir> rbenv local 3.0.3`

Install bundler into that ruby version:

`project_dir> gem install bundler`

Once that is complete install the project specific rubygem dependencies

`project_dir> bundle install`

Create your database

`project_dir> bin/rails db:create`
`project_dir> bin/rails db:migrate`

Run all the tests to sanity check the install

`project_dir> bundle exec rspec`

## Launch the project

From the terminal:

`project_dir> bin/rails s`

then open your browser at `https://localhost:3000/articles`

`project_dir> open https://localhost:3000/articles`

## Assumptions and design decisions

This is a very lightweight implementation. It's not much to look at.

* Chose not to syncronise every piece of data from the S3 aritcle catalog, just a few basics.
* Lots of testing, at the system test level which hits the whole stack and checks the views
* request specs to cover controller behaviour
* basic model specs for skinny models (shoulda matchers for validations and associations only)
* better unit specs for service classes which do the grunt work and are more solid than the rails boilerplate
* Used rubocop to keep things clean, and added some rule eliminations for rails boilerplate code that conflicts with community style guidelines.
* *mostly* achieved the fact that no data is destroyed, but we use the S3Download model (where the JSON is stored) as a bit of silver hammer
