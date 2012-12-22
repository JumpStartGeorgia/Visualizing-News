class CreateOrganizationUsers < ActiveRecord::Migration
  def change
    create_table :organization_users do |t|
      t.integer :organization_id
      t.integer :user_id
      t.boolean :is_active, :default => true

      t.timestamps
    end

		add_index :organization_users, :organization_id
		add_index :organization_users, :user_id
		add_index :organization_users, :is_active
  end
end
