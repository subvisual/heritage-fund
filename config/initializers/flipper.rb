
require 'flipper/adapters/active_record'

if ActiveRecord::Base.connection.table_exists? :flipper_features
  Flipper.configure do |config|
    config.default do
      adapter = Flipper::Adapters::ActiveRecord.new
      Flipper.new(adapter)
    end
    # We start the app with business as usual functionality disabled.
    # To enable, insert a bau flipper as per README.
    Flipper[:bau].add
  end
end