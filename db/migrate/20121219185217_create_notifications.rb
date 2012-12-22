class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :notification_type
      t.integer :identifier

      t.timestamps
    end

		add_index :notifications, :user_id
		add_index :notifications, [:notification_type, :identifier], :name => 'idx_notif_type'
  end
end
