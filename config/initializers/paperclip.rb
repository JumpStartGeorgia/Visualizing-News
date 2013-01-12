Paperclip.interpolates('type') do |attachment, style|
  attachment.instance.type_name
end
Paperclip.interpolates('visual_id') do |attachment, style|
  attachment.instance.visualization_translation.visualization_id
end
Paperclip.interpolates('permalink') do |attachment, style|
  attachment.instance.visualization_translation.permalink
end
Paperclip.interpolates('locale') do |attachment, style|
  attachment.instance.visualization_translation.locale
end
