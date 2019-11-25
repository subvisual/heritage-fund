# Funding frontend

## Steps to run locally

### Prerequisites
* Install Ruby version specified in [.ruby-version](.ruby-version). Recommended to do this through `rbenv` to manage Ruby versions on your machine

* Install [Postgres.app](https://postgresapp.com/)

* Download credentials and save as `.env` in checkout directory (Ask a team member for location)

* `gem install bundler`

* `bundle install`

* `yarn install`

* `rails db:setup`

### Running the app
#### Backend
* `bundle exec rails s`

#### Frontend
In a separate terminal tab run:

`./bin/webpack --watch`









