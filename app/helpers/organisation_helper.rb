module OrganisationHelper
  # Checks for the presence of mandatory organisation parameters,
  # returning false if any are not present and true if all are
  # present
  #
  # @param [Organisation] organisation An instance of Organisation
  def complete_organisation_details?(organisation)
    [
      organisation.name.present?,
      organisation.line1.present?,
      organisation.townCity.present?,
      organisation.county.present?,
      organisation.postcode.present?,
      organisation.org_type.present?,
      organisation.legal_signatories.exists?
    ].all?
  end
end
