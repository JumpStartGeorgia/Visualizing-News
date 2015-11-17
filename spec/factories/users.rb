FactoryGirl.define do
  factory :user do
    sequence :nickname do |n|
      "test user #{n}"
    end

    sequence :email do |n|
      "test_email_#{n}@example.com"
    end

    password 'sadjflj3rWEFREFD@#$!@#$DF'
    role 99
  end
end
