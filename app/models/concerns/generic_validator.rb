module GenericValidator
  extend ActiveSupport::Concern

  def validate_file_attached(field, error_msg)
    unless self.public_send(field).attached?
      errors.add(field, error_msg)
    end
  end

  def validate_length(field, max_length, error_msg)

    word_count = self.public_send(field)&.split(' ')&.count

    logger.debug "#{field} word count is #{word_count}"

    if word_count && word_count > max_length
      self.errors.add(field, error_msg)
    end

  end

end