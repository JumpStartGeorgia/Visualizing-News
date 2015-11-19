FactoryGirl.define do
  factory :visualization do
    visualization_type_id 1 # default type infographic
    organization
    languages 'en'

    before :create do |visualization|
      visualization.load_languages_internal
    end

    factory :video_visualization do
      visualization_type_id 5

      # Add video visualization translations
      transient do
        visualization_translations_count 1
      end

      after :create do |visualization, evaluator|
        create_list(:video_visualization_translation,
                    evaluator.visualization_translations_count,
                    visualization: visualization)
      end

      factory :video_visualization_published do
        published true
        published_date Time.now
      end
    end
  end
end
