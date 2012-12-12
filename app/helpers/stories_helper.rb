module StoriesHelper
  
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
