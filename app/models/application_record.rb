class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  nilify_blanks

  def update(params)
    super params
  rescue ActiveRecord::MultiparameterAssignmentErrors => e
    e.errors.each do |error|
      errors.add(
        error.attribute,
        I18n.t("activerecord.errors.models.#{self.class.name.underscore}.attributes.#{error.attribute}.invalid")
      )
    end
    false
  end
end
