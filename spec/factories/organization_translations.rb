FactoryGirl.define do
  factory :organization_translation do
    organization
    locale :en

    sequence :name do |n|
      "test organization #{n}"
    end

    permalink do
      Utf8Converter.convert_ka_to_en(name).to_ascii.downcase.gsub(' ', '-')
    end
  end
end
