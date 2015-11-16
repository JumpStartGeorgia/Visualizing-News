FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "test category #{n}"
    end
  end
end
