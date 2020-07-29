FactoryBot.define do

    factory :funding_application do
      association :organisation,
                  factory: :organisation,
                  strategy: :build
      association :gp_hef_loan,
                  factory: :gp_hef_loan,
                  strategy: :build
    end
  
  end
  