class IncreaseLimitOfVideoEmbed < ActiveRecord::Migration
  def up
    change_column :visualization_translations,
                  :video_embed,
                  :string,
                  limit: 1000
  end

  def down
    change_column :visualization_translations,
                  :video_embed,
                  :string,
                  limit: 255
  end
end
