module ObjectErrorsLogger
  extend ActiveSupport::Concern

  # This method writes a debug log line for each error found in a model object's errors hash
  def log_errors(model_object)

    model_object.errors.each do |k, v|
      logger.debug "Error '#{v}', for key '#{k}'"
    end

  end

end