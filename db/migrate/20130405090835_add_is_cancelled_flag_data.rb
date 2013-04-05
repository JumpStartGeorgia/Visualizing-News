class AddIsCancelledFlagData < ActiveRecord::Migration
  def up
    status_id = 8
    i = IdeaStatus.find(status_id)
    i.is_cancelled = true
    i.save
    IdeaProgress.where(:idea_status_id => status_id).update_all(:is_cancelled => true)
  end

  def down
    IdeaStatus.update_all(:is_cancelled => false)
    IdeaProgress.update_all(:is_cancelled => false)
  end
end
