class PaProjectEnquiry < ApplicationRecord

  # This overrides Rails attempting to pluralise the model name
  self.table_name = "pa_project_enquiries"
  belongs_to :pre_application

  attr_accessor :validate_heritage_focus
  attr_accessor :validate_what_project_does
  attr_accessor :validate_programme_outcomes
  attr_accessor :validate_project_reasons
  attr_accessor :validate_project_participants
  attr_accessor :validate_project_timescales
  attr_accessor :validate_project_likely_cost
  attr_accessor :validate_potential_funding_amount

  validates :heritage_focus, presence: true, if: :validate_heritage_focus?
  validates :what_project_does, presence: true, if: :validate_what_project_does?
  validates :programme_outcomes, presence: true, if: :validate_programme_outcomes?
  validates :project_reasons, presence: true, if: :validate_project_reasons?
  validates :project_participants, presence: true, if: :validate_project_participants?
  validates :project_timescales, presence: true, if: :validate_project_timescales?
  validates :project_likely_cost, presence: true, if: :validate_project_likely_cost?
  validates :potential_funding_amount, numericality: {
    only_integer: true,
    greater_than: 0
  }, if: :validate_potential_funding_amount?

  def validate_heritage_focus?
    validate_heritage_focus == true
  end

  def validate_what_project_does?
    validate_what_project_does == true
  end

  def validate_programme_outcomes?
    validate_programme_outcomes == true
  end

  def validate_project_reasons?
    validate_project_reasons == true
  end

  def validate_project_participants?
    validate_project_participants == true
  end

  def validate_project_timescales?
    validate_project_timescales == true
  end

  def validate_project_likely_cost?
    validate_project_likely_cost == true
  end

  def validate_potential_funding_amount?
    validate_potential_funding_amount == true
  end

end