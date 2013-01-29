class AddIsPublicData < ActiveRecord::Migration
  def up
    Idea.all.each do |idea|
      idea.is_public = !idea.is_private
      idea.save
    end

    IdeaProgress.all.each do |prog|
      prog.is_public = !prog.is_private
      prog.save
    end
  end

  def down
    Idea.update_all(:is_public => 0)
    IdeaProgress.update_all(:is_public => 0)
  end
end
