class AddUserNotificationFlag < ActiveRecord::Migration
  def change
		add_column :users, :wants_notifications, :boolean, :default => true
		add_index :users, :wants_notifications
  end
end
