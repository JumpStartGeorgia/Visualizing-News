class CreateVoterIps < ActiveRecord::Migration
  def change
    create_table :voter_ips do |t|
      t.string :ip, :limit => 50, :default => ""
      t.string :votable_type
      t.integer :votable_id
      t.string :status

      t.timestamps
    end

		add_index :voter_ips, [:ip, :votable_type, :votable_id, :status], :name => 'idx_voter_ip'
  end
end
