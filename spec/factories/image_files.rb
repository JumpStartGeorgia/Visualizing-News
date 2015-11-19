FactoryGirl.define do
  factory :image_file do
    visualization_translation
    #
    # file do
    #   File.new(
    #     Rails.root.join(
    #       'spec',
    #       'example_files',
    #       'how-dependent-is-georgia-on-russia-economically_en_medium.jpg'
    #     )
    #   )
    # end
  end
end
