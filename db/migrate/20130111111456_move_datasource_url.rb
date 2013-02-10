class MoveDatasourceUrl < ActiveRecord::Migration
  def change
		add_column :visualization_translations, :data_source_url, :string
		rename_column :visualizations, :data_source_url, :data_source_url_old
  end

end
