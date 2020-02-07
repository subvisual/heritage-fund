FactoryBot.define do

  factory :user do |f|
    association :organisation,
                factory: :organisation,
                strategy: :create

    f.confirmed_at { "2020-02-05 12:20:14.391143" }
    f.email { "test@test.com" }
    f.password { "password" }
  end

end
