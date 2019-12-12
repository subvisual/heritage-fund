class Organisation < ApplicationRecord
    has_many :users

    enum org_type: {
        registered_charity: 0,
        local_authority: 1,
        registered_company: 2,
        community_interest_company: 3,
        faith_based_organisation: 4,
        church_organisation: 5,
        community_group: 6,
        voluntary_group: 7,
        individual_private_owner_of_heritage: 8,
        other: 9}

    enum mission: {
        black_or_minority_ethnic_led: 0,
        disability_led: 1,
        lgbt_plus_led: 2,
        female_led: 3,
        young_people_led: 4
    }

end