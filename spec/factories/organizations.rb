FactoryGirl.define do
  factory :organization do
    transient do
      organization_translations_count 1
    end

    after :create do |organization, evaluator|
      create_list(:organization_translation,
                  evaluator.organization_translations_count,
                  organization: organization)
    end
  end
end
