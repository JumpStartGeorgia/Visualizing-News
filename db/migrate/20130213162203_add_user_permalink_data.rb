class AddUserPermalinkData < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.permalink = user.nickname.downcase.gsub('.', '-').gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')
      user.save
    end 
  end

  def down
    User.update_all(:permalink => nil)
  end
end
