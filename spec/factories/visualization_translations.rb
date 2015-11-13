FactoryGirl.define do
  factory :visualization_translation do
    visualization
    locale 'en'
    sequence :title do |n|
      "test visualization title #{n}"
    end

    after :create do |visualization_translation|
      visualization_translation.create_permalink
    end
  end
end
