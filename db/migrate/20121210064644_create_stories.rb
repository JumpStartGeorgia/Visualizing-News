class CreateStories < ActiveRecord::Migration
  def up
    create_table :stories do |t|
      t.datetime :published_date
      t.boolean :published, :default => false
      t.integer :story_type_id
      t.string :data_source_url
      t.string :individual_votes
      t.integer :overall_votes, :default => 0

      t.timestamps
    end

		add_index :stories, :published_date
		add_index :stories, :published
		add_index :stories, :overall_votes
		add_index :stories, :story_type_id

		Story.create_translation_table! :title => :string, :explanation => :text,
																		:reporter => :string, :designer => :string,
																		:data_source_name => :string

  end

	def down
		remove_index :stories, :published_date
		remove_index :stories, :published
		remove_index :stories, :overall_votes
		remove_index :stories, :story_type_id

		Story.drop_translation_table!
		drop_table :stories
	end
end
