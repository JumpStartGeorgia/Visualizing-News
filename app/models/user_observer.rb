class UserObserver < ActiveRecord::Observer

	def after_create(user)
		user.send_notification = true if !user.db_migrate && Rails.env.production?
	end

	# after user has been created, send welcome message
	def after_commit(user)
		# only process if a create just occurred
		if user.send_notification
			message = Message.new
      message.email = user.email
			message.locale = user.notification_language
			message.subject = I18n.t("mailer.notification.new_user.subject", :locale => user.notification_language)
			message.message = I18n.t("mailer.notification.new_user.message", :locale => user.notification_language)
			NotificationMailer.new_user(message).deliver
			user.send_notification = false # make sure duplicate messages are not sent
		end
	end
end
