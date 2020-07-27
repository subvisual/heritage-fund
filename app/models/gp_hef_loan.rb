class GpHefLoan < ApplicationRecord
  include GenericValidator

  belongs_to :funding_application, optional: true

  has_many :gp_hef_loans_org_income_types, inverse_of: :gp_hef_loan
  has_many :org_income_types, through: :gp_hef_loans_org_income_types

  has_many :gp_hef_loans_plans_for_loans, inverse_of: :gp_hef_loan
  has_many :plans_for_loans, through: :gp_hef_loans_plans_for_loans

  has_many :gp_hef_loans_repayment_freqs, inverse_of: :gp_hef_loan
  has_many :repayment_frequencies, through: :gp_hef_loans_repayment_freqs

  has_many_attached :supporting_documents_files

  accepts_nested_attributes_for :gp_hef_loans_org_income_types, allow_destroy: true
  accepts_nested_attributes_for :gp_hef_loans_repayment_freqs, allow_destroy: true
  accepts_nested_attributes_for :gp_hef_loans_plans_for_loans, allow_destroy: true

  attr_accessor :has_custom_org_income_type

  attr_accessor :validate_previous_project_reference
  attr_accessor :validate_can_legally_take_on_debt
  attr_accessor :validate_any_debt_restrictions
  attr_accessor :validate_debt_description
  attr_accessor :validate_can_provide_security
  attr_accessor :validate_security_restrictions
  attr_accessor :validate_security_description
  attr_accessor :validate_has_had_an_average_yearly_cash_surplus
  attr_accessor :validate_average_yearly_cash_surplus
  attr_accessor :validate_has_had_a_surplus_in_last_reporting_year
  attr_accessor :validate_cash_surplus_in_last_year
  attr_accessor :validate_org_income_types
  attr_accessor :validate_custom_org_income_type
  attr_accessor :validate_bankruptcy_or_administration
  attr_accessor :validate_bankruptcy_or_administration_description
  attr_accessor :validate_considers_state_aid
  attr_accessor :validate_has_applied_for_grant_or_loan
  attr_accessor :validate_other_funding_details
  attr_accessor :validate_efforts_to_reduce_borrowing
  attr_accessor :validate_plans_for_loan_description
  attr_accessor :validate_loan_amount_requested
  attr_accessor :validate_time_to_repay_loan
  attr_accessor :validate_cashflow_understanding
  attr_accessor :validate_supporting_documents_files

  validates :previous_project_reference, presence: true,
    if: :validate_previous_project_reference?
  validates_inclusion_of :can_legally_take_on_debt, in: [true, false],
    if: :validate_can_legally_take_on_debt?
  validates_inclusion_of :any_debt_restrictions, in: [true, false],
    if: :validate_any_debt_restrictions?
  validates :debt_description, presence: true,
    if: :validate_debt_description?
  validates_inclusion_of :can_provide_security, in: [true, false],
    if: :validate_can_provide_security?
  validates_inclusion_of :security_restrictions, in: [true, false], 
    if: :validate_security_restrictions?
  validates :security_description, presence: true, 
    if: :validate_security_description?
  validates_inclusion_of :has_had_an_average_yearly_cash_surplus, in: [true, false],
    if: :validate_has_had_an_average_yearly_cash_surplus?

  validates :average_yearly_cash_surplus, 
    numericality: {
      only_integer: true,
      greater_than: 0
    }, if: :validate_average_yearly_cash_surplus?

  validates_inclusion_of :has_had_a_surplus_in_last_reporting_year, in: [true, false], 
    if: :validate_has_had_a_surplus_in_last_reporting_year?

  validates :cash_surplus_in_last_year, 
    numericality: {
      only_integer: true,
      greater_than: 0
    }, if: :validate_cash_surplus_in_last_year?

  validate :custom_validator_for_org_income_types, 
    if: :validate_org_income_types?
  validates :custom_org_income_type, presence: true, 
    if: :validate_custom_org_income_type?
  validates_inclusion_of :bankruptcy_or_administration, in: [true, false], 
    if: :validate_bankruptcy_or_administration?
  validates :bankruptcy_or_administration_description, presence: true, 
    if: :validate_bankruptcy_or_administration_description?
  validates_inclusion_of :considers_state_aid, in: [true, false], 
    if: :validate_considers_state_aid?
  validates_inclusion_of :has_applied_for_grant_or_loan, in: [true, false], 
    if: :validate_has_applied_for_grant_or_loan?
  validates :other_funding_details, presence: true, 
    if: :validate_other_funding_details?
  validates :efforts_to_reduce_borrowing, presence: true, 
    if: :validate_efforts_to_reduce_borrowing?
  validates :plans_for_loan_description, presence: true, 
    if: :validate_plans_for_loan_description?

  validates :loan_amount_requested, 
    numericality: {
      only_integer: true
    }, 
    :inclusion => 50000..250000,
    if: :validate_loan_amount_requested?

  validates :time_to_repay_loan, 
    numericality: {
      only_integer: true,
      greater_than: 0
    }, if: :validate_time_to_repay_loan?

  validates_inclusion_of :cashflow_understanding, in: ["true"], 
    if: :validate_cashflow_understanding?

  def validate_previous_project_reference?
    validate_previous_project_reference == true
  end

  def validate_can_legally_take_on_debt?
    validate_can_legally_take_on_debt == true
  end

  def validate_any_debt_restrictions?
    validate_any_debt_restrictions == true
  end

  def validate_debt_description?
    validate_debt_description == true
  end

  def validate_can_provide_security?
    validate_can_provide_security == true
  end

  def validate_security_restrictions?
    validate_security_restrictions == true
  end

  def validate_security_description?
    validate_security_description == true
  end

  def validate_has_had_an_average_yearly_cash_surplus?
    validate_has_had_an_average_yearly_cash_surplus == true
  end

  def validate_average_yearly_cash_surplus?
    validate_average_yearly_cash_surplus == true
  end

  def validate_has_had_a_surplus_in_last_reporting_year?
    validate_has_had_a_surplus_in_last_reporting_year == true
  end

  def validate_cash_surplus_in_last_year?
    validate_cash_surplus_in_last_year == true
  end

  def validate_org_income_types?
    validate_org_income_types == true
  end

  def validate_custom_org_income_type?
    validate_custom_org_income_type == true
  end

  def validate_bankruptcy_or_administration?
    validate_bankruptcy_or_administration == true
  end

  def validate_bankruptcy_or_administration_description?
    validate_bankruptcy_or_administration_description == true
  end

  def validate_considers_state_aid?
    validate_considers_state_aid == true
  end

  def validate_has_applied_for_grant_or_loan?
    validate_has_applied_for_grant_or_loan == true
  end

  def validate_other_funding_details?
    validate_other_funding_details == true
  end

  def validate_efforts_to_reduce_borrowing?
    validate_efforts_to_reduce_borrowing == true
  end

  def validate_plans_for_loan_description?
    validate_plans_for_loan_description == true
  end

  def validate_loan_amount_requested?
    validate_loan_amount_requested == true
  end

  def validate_time_to_repay_loan?
    validate_time_to_repay_loan == true
  end

  def validate_cashflow_understanding?
    validate_cashflow_understanding == true
  end

  def validate_supporting_documents_files?
    validate_supporting_documents_files == true
  end

  validate do
    validate_file_attached(
        :supporting_documents_files,
        I18n.t("activerecord.errors.models.gp_hef_loan.attributes.supporting_documents_files.inclusion")
    ) if validate_supporting_documents_files?
  end

end
