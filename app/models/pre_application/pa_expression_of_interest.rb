class PaExpressionOfInterest < ApplicationRecord
  # This overrides Rails attempting to pluralise the model name
  self.table_name = "pa_expressions_of_interest"
    belongs_to :pre_application
end