class MoveDatasourceData < ActiveRecord::Migration
  def up
    VisualizationTranslation.where("data_source_name_old is not null and data_source_name_old != ''").each do |trans|
      trans.datasources.create(:name => trans.data_source_name_old, :url => trans.data_source_url_old)
    end
  end

  def down
    Datasource.delete_all
  end
end
