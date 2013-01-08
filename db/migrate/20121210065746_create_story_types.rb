class CreateStoryTypes < ActiveRecord::Migration
  def up
    create_table :story_types do |t|
      t.timestamps
    end

		StoryType.create_translation_table! :name => :string
  end

	def down
		StoryType.drop_translation_table!
		drop_table :story_types
	end
end
