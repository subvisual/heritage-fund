# Funding frontend

## Steps to run locally

### Prerequisites

* Install home brew
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

* Install rbenv `brew install rbenv`

* Install postgres `brew install postgres`

* Install Ruby version specified in [.ruby-version](.ruby-version). Recommended to do this through `rbenv` to manage Ruby versions on your machine

* `rbenv install X.X.X` (replace X.X.X with the version detailed in [.ruby-version](.ruby-version)) 

* If you use rbenv ensure the following line is added to your bash_profile (`~/.bash_profile`): `eval "$(rbenv init -)"`

* Install [Postgres.app](https://postgresapp.com/)

* Download credentials and save as `.env` in checkout directory (Ask a team member for location)

* Install the pg gem telling it the path of postgress, typically this is: 
`gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/latest/bin/pg_config`

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

`./bin/webpack --watch` (or `npm start` if you have node package manager installed)

### Deploying the app
#### Staging
`master` branch is deployed automatically by GitHub actions
#### Research
From your local machine run `cf v3-push funding-frontend-research`










