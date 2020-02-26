require_relative 'boot'

require 'rails/all'
require 'action_view/component/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

HOSTNAME = ENV['HOSTNAME']

module FundingFrontendRuby
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.assets.paths << Rails.root.join('node_modules')
    config.i18n.default_locale = :'en-GB'
    config.i18n.fallbacks = true
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid

      hacker = Module.new do
        def options_for_migration
          ar = Rails.application.config.generators.active_record
          return super unless %i[belongs_to references].include?(type) && \
                              ar[:primary_key_type] == :uuid
    
          { type: :uuid }.merge(super)
        end
      end
      require 'rails/generators/generated_attribute'
      Rails::Generators::GeneratedAttribute.prepend hacker
    end
    # config.active_record.schema_format = :sql

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
