FactoryGirl.define do
  factory :visualization do
    visualization_type_id 1 # default type infographic
    organization
    languages 'en'

    transient do
      visualization_translations_count 1
    end

    after :create do |visualization, evaluator|
      create_list(:visualization_translation,
                  evaluator.visualization_translations_count,
                  visualization: visualization)
    end

    factory :video_visualization do
      visualization_type_id 5

      before :create do |visualization|
        visualization.load_languages_internal
      end
    end
  end
end
