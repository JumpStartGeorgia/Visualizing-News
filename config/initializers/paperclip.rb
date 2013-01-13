Paperclip.interpolates('visual_id') do |attachment, style|
  attachment.instance.visualization_translation.visualization_id
end
Paperclip.interpolates('permalink') do |attachment, style|
  attachment.instance.visualization_translation.permalink
end
Paperclip.interpolates('locale') do |attachment, style|
  attachment.instance.visualization_translation.locale
end
Paperclip.interpolates('upload_file_name') do |attachment, style|
  attachment.instance.upload_file_name
end
