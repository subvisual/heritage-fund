FactoryBot.define do
  factory :user do |f|
    users_organisations do [FactoryBot.build(:users_organisation)] end
    # association :organisation,
    #             factory: :organisation,
    #             strategy: :create

    association :person,
      factory: :person,
      strategy: :create

    f.confirmed_at do "2020-02-05 12:20:14.391143" end
    sequence(:email) do |n| "user#{n}@example.com" end
    f.password do "password" end

    f.name do "Joe Bloggs" end
    f.date_of_birth do Date.parse("01-01-1980") end
    f.phone_number do "07123456789" end
    f.line1 do "10 Downing Street" end
    f.line2 do "Westminster" end
    f.townCity do "London" end
    f.county do "LONDON" end
    f.postcode { "SW1A 2AA" }
  end
end
