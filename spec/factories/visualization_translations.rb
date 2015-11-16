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

    factory :video_visualization_translation do
      video_url 'http://www.youtube.com/not-sure-what-path-to-put-here'
    end
  end
end
