module VisualizationsHelper

	def create_visual_path(visualization_id, user_in_org=false, organization_id=nil)
		if user_in_org && organization_id
			organization_visualization_path(organization_id,visualization_id, remove_unwanted_params(@param_options))
		else
			visualization_path(visualization_id, remove_unwanted_params(@param_options))
		end
	end

  def visualization_type_name(id)
    index = Visualization::TYPES.values.index(id)
    I18n.t("visualization_types.#{Visualization::TYPES.keys[index]}") if index
  end

	def visualization_type_collection
	  col = []
    Visualization::TYPES.keys.each do |key|
	    col << [I18n.t("visualization_types.#{key}"), Visualization::TYPES[key]]
	  end
	  return col
  end

  # options = [{key, value}]
  def merge_visual_params(options)
    p = @param_options.clone
    options.each do |option|
      if !option[:key].blank? && !option[:value].blank?
        p[option[:key].to_s] = option[:value]
      end
    end
    return p
  end

	def vis_item_image_tag_classes(visualization)
		image_tag_classes = []
		
		if visualization.type == :gifographic
			image_tag_classes.append 'js-freeze-gifographic'
		end

		image_tag_classes.join(' ')
	end
end
