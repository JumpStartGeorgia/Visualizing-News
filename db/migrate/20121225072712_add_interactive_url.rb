class AddInteractiveUrl < ActiveRecord::Migration
  def change
		add_column :visualizations, :interactive_url, :string
  end

end
