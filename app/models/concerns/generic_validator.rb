module GenericValidator
  extend ActiveSupport::Concern

  def validate_file_attached(field, error_msg)
    unless public_send(field).attached?
      errors.add(field, error_msg)
    end
  end

  def validate_length(field, max_length, error_msg)
    word_count = public_send(field)&.split(" ")&.count

    logger.debug "#{field} word count is #{word_count}"

    if word_count && word_count > max_length
      errors.add(field, error_msg)
    end
  end
end
