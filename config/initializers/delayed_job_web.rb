if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(Rails.configuration.x.delayed_job_web.username, username) &&
        ActiveSupport::SecurityUtils.secure_compare(Rails.configuration.x.delayed_job_web.password, password)
  end
end
