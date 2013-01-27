class IdeaObserver < ActiveRecord::Observer

	def after_create(idea)
	Rails.logger.debug "===== idea create obs; idea send = #{idea.send_notification}; is private = #{idea.is_private}"
		idea.send_notification = true if !idea.is_private && !idea.db_migrate
	Rails.logger.debug "===== idea create obs end; idea send = #{idea.send_notification}"
	end

	# after an idea has been created, notify subscribers
	def after_commit(idea)
	Rails.logger.debug "===== idea after commit obs; idea send = #{idea.send_notification}"
		if idea.send_notification
	Rails.logger.debug "===== - sending notification"
			category_ids = idea.idea_categories.map{|x| x.category_id}
			if category_ids && !category_ids.empty?
				I18n.available_locales.each do |locale|
	Rails.logger.debug "===== - locale = #{locale}"
				  message = Message.new
				  message.bcc = Notification.new_idea_users(category_ids, locale)
				  if message.bcc && !message.bcc.empty?
	Rails.logger.debug "===== - have bcc"
					  # if the owner is a subscriber, remove from list
					  index = message.bcc.index(idea.user.email)
					  message.bcc.delete_at(index) if index
					  # only continue if owner was not only subscriber
					  if message.bcc.length > 0
	Rails.logger.debug "===== - still have bcc, sending"
  						message.locale = locale
						  message.subject = I18n.t("mailer.notification.new_idea_subscriber.subject")
						  message.message = I18n.t("mailer.notification.new_idea_subscriber.message")
						  message.org_message = idea.explaination
						  message.url_id = idea.id
						  NotificationMailer.new_idea_subscriber(message).deliver
					  end
				  end
			  end
  		end
		end
	end
end
