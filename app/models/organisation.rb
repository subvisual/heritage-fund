class Organisation < ApplicationRecord
    has_many :users
    enum type: {
        registered_charity: 'registered_charity',
        local_authority: 'local_authority',
        registered_company: 'registered_company',
        community_interest_company: 'community_interest_company',
        faith_based_organisation: 'faith_based_organisation',
        church_organisation: 'church_organisation',
        community_group: 'community_group',
        voluntary_group: 'voluntary_group',
        individual_private_owner_of_heritage: 'individual_private_owner_of_heritage',
        other: 'other'}
end