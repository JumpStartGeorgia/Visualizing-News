class NotificationMailer < ActionMailer::Base
  default :from => ENV['FERADI_NOREPLY_FEEDBACK_FROM_EMAIL']
	layout 'mailer'

  ######### users

  def new_user(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  ######### visuals

  def new_visualization(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def new_visualization_needs_promotion(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def visualization_comment(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def visualization_promoted(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  ######### idea subscribers
  def new_idea_subscriber(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def idea_comment_subscriber(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

  def idea_claimed_subscriber(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_progress_update_subscriber(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_realized_subscriber(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  ######## idea owner
  def idea_claimed_owner(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_progress_update_owner(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_realized_owner(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end

  def idea_comment_owner(message)
    @message = message
    mail(:to => message.email, :subject => message.subject)
  end


end
