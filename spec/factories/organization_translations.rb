FactoryGirl.define do
  factory :organization_translation do
    organization
    locale :en

    sequence :name do |n|
      "test organization #{n}"
    end
  end
end
