class Project < ApplicationRecord
    belongs_to :user
    has_many :released_forms
    has_many_attached :evidence_of_support_files

    def to_salesforce_json
        Jbuilder.encode do |json|
            json.ignore_nil!
            json.meta do
                json.set!('applicationId', self.id)
                json.set!('form', "3-10k-grant")
                json.set!('schemaVersion', "v1.x")
                json.set!('startedAt', self.created_at)
                json.set!('username', self.user.email)
            end
            json.application do
                json.set!('organisationName', self.user.organisation.name)
                json.set!('organisationMission',
                          self.user.organisation.mission.map!(&:dasherize).map { |m| m == 'lgbt-plus-led' ? 'lgbt+-led' : m })
                json.set!('organisationType', self.user.organisation.org_type.dasherize)
                json.set!('companyNumber', self.user.organisation.company_number&.to_s)
                json.set!('charityNumber', self.user.organisation.charity_number&.to_s)
                json.organisationAddress do
                    json.line1 self.user.organisation.line1
                    json.line2 self.user.organisation.line2
                    json.line3 self.user.organisation.line3
                    json.county self.user.organisation.county
                    json.townCity self.user.organisation.townCity
                    json.postcode self.user.organisation.postcode
                end
                set_legal_signatory_fields = ->(ls) {
                    json.set!("name", ls.name)
                    json.set!("email", ls.email_address)
                    json.set!("phone", ls.phone_number)
                }
                @ls_one = self.user.organisation.legal_signatories.first
                json.authorisedSignatoryOneDetails do
                    set_legal_signatory_fields.call(@ls_one)
                end
                @ls_two = self.user.organisation.legal_signatories.second
                if @ls_two.present?
                    json.authorisedSignatoryTwoDetails do
                        set_legal_signatory_fields.call(@ls_two)
                    end
                end
            end
        end
    end
end
