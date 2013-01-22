class NotificationMailer < ActionMailer::Base
  default :from => ENV['FERADI_NOREPLY_FEEDBACK_FROM_EMAIL']
	layout 'mailer'

  def new_user(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def new_visualization(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def visualization_comment(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

end
