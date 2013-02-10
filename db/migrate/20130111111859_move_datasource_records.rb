class MoveDatasourceRecords < ActiveRecord::Migration
  def up
		Visualization.where("data_source_url_old is not null and data_source_url_old != ''").each do |vis|
			vis.visualization_translations.each do |trans|
				trans.data_source_url = vis.data_source_url_old
				trans.save
			end
		end
  end

  def down
		VisualizationTranslation.update_all(:data_source_url => nil)
  end
end
