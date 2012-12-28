module VisualizationsHelper

	def create_visual_path(visualization_id, user_in_org=false, organization_id=nil)
		if user_in_org && organization_id
			organization_visualization_path(organization_id,visualization_id)
		else
			visualization_path(visualization_id)
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

  def votes_cont (obj)
    ip = request.remote_ip
    type = obj.class.name.downcase

    if obj.voted(ip, 'up')
      html = image_tag('thumbs-up-grey.png')
    else
      html = link_to image_tag('thumbs-up.png'), vote_path(:type => type, :votable_id => obj.id, :status => 'up')
    end

    diff = obj.votes_diff
    html += content_tag(:span, diff[:number], :style => "margin:0 5px;color:" + diff[:color])

    if obj.voted(ip, 'down')
      html += image_tag('thumbs-down-grey.png')
    else
      html += link_to image_tag('thumbs-down.png'), vote_path(:type => type, :votable_id => obj.id, :status => 'down')
    end
    html
  end

end
