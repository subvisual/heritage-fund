# Funding frontend

## Steps to run locally

### Prerequisites

* Install Ruby version specified in [.ruby-version](.ruby-version). Recommended to do this through `rbenv` to manage Ruby versions on your machine

* If you use rbenv ensure the following line is added to your bash_profile (`~/.bash_profile`): `eval "$(rbenv init -)"`

* Install [Postgres.app](https://postgresapp.com/)

* Download credentials and save as `.env` in checkout directory (Ask a team member for location)

* `gem install bundler`

* `bundle install`

* Install yarn (https://yarnpkg.com/lang/en/docs/install/#mac-stable)

* `yarn install`

* `rails db:setup`

### Running the app
#### Backend
* `bundle exec rails s`

* open: http://localhost:3000

#### Frontend
In a separate terminal tab run:

`./bin/webpack --watch`









