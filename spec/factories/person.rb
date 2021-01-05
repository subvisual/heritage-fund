FactoryBot.define do
  factory :person do |f|
    f.name do "Jean-Luc Picard" end
    f.date_of_birth do Date.parse("01-01-1980") end
    f.email do "jean.luc.picard@starfleet.gov" end
    f.phone_number do "07123456789" end
    f.position { "Captain" }
  end
end
