FactoryBot.define do

    factory :funding_application do
      association :organisation,
                  factory: :organisation,
                  strategy: :build
      association :project,
                  factory: :project,
                  strategy: :build
    end
  
  end
  