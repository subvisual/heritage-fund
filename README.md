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

`master` branch is deployed automatically by GitHub Actions.

#### Research

From your local machine run `cf v3-push funding-frontend-research`.

# Guides

## How to create a new page

You can use the `rails generate` command to create new pages in the application.

Assuming that we want to create a new page within the 'projects' section of the
 application, the following command will create the necessary boilerplate:

```bash
rails generate controller Project::MyPage show
```

This will output the following within the console:

```bash
Running via Spring preloader in process 15958
      create  app/controllers/project/my_page_controller.rb
       route  namespace :project do
  get 'my_page/show'
end
      invoke  erb
      create    app/views/project/my_page
      create    app/views/project/my_page/show.html.erb
      invoke  rspec
      create    spec/requests/project/my_page_request_spec.rb
      create    spec/views/project/my_page
      create    spec/views/project/my_page/show.html.erb_spec.rb
      invoke  helper
      create    app/helpers/project/my_page_helper.rb
      invoke    rspec
      create      spec/helpers/project/my_page_helper_spec.rb
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/project/my_page.scss
```

The `app/views/project/my_page/show.html.erb` file contains the HTML markdown 
that will be displayed when a user visits the page.

The final thing to do here is to amend the `config/routes.rb` file to ensure 
that we have added a route to our generated controller and `show` method. 
In this example, we need to add an additional route within the 'projects' 
section of `config/routes.rb`. You can find this by looking for the following:

```bash
scope "/3-10k", as: :three_to_ten_k do
    namespace :project do    
```

Inside this `namespace` block of code, add the following line:

```bash
get 'my-page', to: 'my_page#show'
```

Where `'my-page'` is the URL you would like (in this example, the full URL would
be `.../3-10k/project/<project_id>/my-page`), and where `'my_page#show'` is the 
name you gave to the controller in the first command entered 
(`rails generate controller Project::MyPage show` - Rails will automatically 
underscore camel-cased names here, such as where we've used `MyPage`).

For more on the Ruby on Rails `generate` command, [see the documentation](
https://guides.rubyonrails.org/command_line.html#rails-generate).