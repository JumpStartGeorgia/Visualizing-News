class AddLangField < ActiveRecord::Migration
  def up
		add_column :users, :notification_language, :string
		add_index :users, :notification_language
  end

  def down
		remove_index :users, :notification_language
		remove_column :users, :notification_language
  end
end
