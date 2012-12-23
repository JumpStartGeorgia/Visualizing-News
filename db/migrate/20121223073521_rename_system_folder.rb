class RenameSystemFolder < ActiveRecord::Migration
  def up
    path = "#{Rails.root}/public/system"
    File.rename("#{path}/story", "#{path}/visualization")
  end

  def down
    path = "#{Rails.root}/public/system"
    File.rename("#{path}/visualization", "#{path}/story")
  end
end
