class CreatePages < ActiveRecord::Migration
  def up
    create_table :pages do |t|
      t.string :name

      t.timestamps
    end
    Page.create_translation_table! :title => :string, :description => :text
  end

  def down
    drop_table :pages
    Page.drop_translation_table!
  end
end
