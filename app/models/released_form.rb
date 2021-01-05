class ReleasedForm < ApplicationRecord
  enum form_type: {permission_to_start: 0, completion_report: 1}
  belongs_to :project
end
