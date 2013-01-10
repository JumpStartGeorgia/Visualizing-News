Paperclip.interpolates('visual_id') do |attachment, style|
  attachment.instance.visualization_id
end
Paperclip.interpolates('permalink') do |attachment, style|
  attachment.instance.permalink
end
Paperclip.interpolates('locale') do |attachment, style|
  attachment.instance.locale
end
