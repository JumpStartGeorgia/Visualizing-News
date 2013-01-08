class ContactMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']
  default :to => ENV['APPLICATION_FEEDBACK_TO_EMAIL']

  def new_message(message)
    @message = message
    mail(:cc => "#{message.name} <#{message.email}>", :subject => I18n.t("mailer.contact.subject"))
  end

  def send_data(message)
    @message = message
    
    # if a file was provided, add it as an attachment
    file = nil
    if @message.file
      file = Tempfile.new("send_data_attachment_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}")
      file.write(@message.file.read)
			file.rewind
      attachments[@message.file.original_filename] = file.read
    end
    
    mail(:cc => "#{message.name} <#{message.email}>", :subject => I18n.t("mailer.send_data.subject"))

    # kill the temp attachment file
    file.close if file
		file.unlink if file
  end

  def submit_visual(message)
    @message = message
    mail(:cc => "#{message.name} <#{message.email}>", :subject => I18n.t("mailer.submit_visual.subject"))
  end

end
