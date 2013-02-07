  class CreateVoteIds < ActiveRecord::Migration
  def change
    create_table :voter_ids do |t|
      t.integer :user_id
      t.string :votable_type
      t.integer :votable_id
      t.string :status

      t.timestamps
    end

    add_index :voter_ids, [:user_id, :votable_type, :votable_id, :status], :name => 'idx_vote_record'
  end
end
