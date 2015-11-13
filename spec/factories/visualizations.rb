FactoryGirl.define do
  factory :visualization do
    visualization_type_id 1 # default type infographic
    organization
    languages 'en,ka'

    factory :video_visualization do
      visualization_type_id 5

      before :create do |visualization|
        visualization.load_languages_internal
      end
    end
  end
end
