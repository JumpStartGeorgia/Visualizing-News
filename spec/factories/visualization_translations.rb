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
      video_url 'https://www.youtube.com/watch?v=KN56RvmK5_Y'
      video_embed do
        '<iframe width="560" height="315" src="https://www.youtube.com/embed/KN56RvmK5_Y" frameborder="0" allowfullscreen=""></iframe>'
      end
    end
  end
end
