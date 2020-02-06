source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
# Pinned to old version due to related issue https://github.com/alphagov/whitehall/issues/4724
gem 'sass-rails', '< 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "pry", "~> 0.12.2"
  # Pinned to beta version due to the bug described in this GitHub issue:
  # https://github.com/rspec/rspec-rails/issues/2086
  gem "rspec-rails", "~> 4.0.0.beta3"
  gem "factory_bot_rails", "~> 5.1"
  gem "rails-controller-testing", "~> 1.0.4"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem "webmock", "~> 3.8"
end

group :production, :staging do
  gem "aws-sdk-s3", require: false
  gem 'cf-app-utils'
  gem "delayed_job_active_record", "~> 4.1"
  gem "sentry-raven", "~> 2.13"
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "dotenv-rails", "~> 2.7", groups: [:development, :test]

gem "pg", "~> 1.1"

gem "restforce", "~> 4.2"

gem "faraday", "~> 0.17.0"

gem "ideal_postcodes", "~> 2.0"

gem "devise", "~> 4.7"

gem "mail-notify", "~> 0.2"

gem "rails-i18n", "~> 6.0"

gem "nilify_blanks", "~> 1.3"


gem "delayed_job_web", "~> 1.4"


gem "lograge", "~> 0.11.2"

gem "silencer", "~> 1.0"
