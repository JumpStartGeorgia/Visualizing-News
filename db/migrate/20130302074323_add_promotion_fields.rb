class AddPromotionFields < ActiveRecord::Migration
  def change
    add_column :visualizations, :is_promoted, :boolean, :default => false
    add_column :visualizations, :promoted_at, :date

    add_index :visualizations, [:is_promoted, :promoted_at], :name => 'idx_visuals_promotion'
  end
end
