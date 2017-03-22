class FixFakeEmail < ActiveRecord::Migration
  def up
    User.where(email: '<%= devise.friendly_token[0,10] %>@fake.com').each do |user|
      user.email = "#{Devise.friendly_token[0,15]}@fake.com"
      user.save
    end
  end

  def down
    puts 'do nothing'
  end
end
