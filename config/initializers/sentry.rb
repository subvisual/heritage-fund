if Rails.env.production? || Rails.env.staging?
  Raven.configure do |config|
    config.async = lambda { |event|
      SentryJob.perform_later(event)
    }
  end
end
