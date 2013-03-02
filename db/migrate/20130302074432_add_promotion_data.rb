class AddPromotionData < ActiveRecord::Migration
  def up
    # promote all visuals that are published
    Visualization.published.update_all(:is_promoted => true, :promoted_at => Date.today.strftime('%F'))
  end

  def down
    Visualization.update_all(:is_promoted => false, :promoted_at => null)
  end
end
