FactoryBot.define do

  factory :person do |f|
    f.name { "Jean-Luc Picard" }
    f.date_of_birth { Date.parse("01-01-1980") }
    f.email { "jean.luc.picard@starfleet.gov" }
    f.phone_number { "07123456789" }
    f.position { "Captain" }
  end

end
