if Rails.env.production? || Rails.env.staging?
  Delayed::Worker.logger = Rails.logger
  Delayed::Worker.destroy_failed_jobs = false
  Delayed::Worker.max_attempts = 2
end
