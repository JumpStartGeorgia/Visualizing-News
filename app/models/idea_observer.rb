class IdeaObserver < ActiveRecord::Observer

	def after_create(idea)
		idea.send_notification = true if idea.is_public && !idea.db_migrate
	end

	# after an idea has been created, notify subscribers
	def after_commit(idea)
		if idea.send_notification
			category_ids = idea.idea_categories.map{|x| x.category_id}
			if category_ids && !category_ids.empty?
				I18n.available_locales.each do |locale|
				  message = Message.new
				  message.bcc = Notification.new_idea_users(category_ids, locale)
				  if message.bcc && !message.bcc.empty?
					  # if the owner is a subscriber, remove from list
					  index = message.bcc.index(idea.user.email)
					  message.bcc.delete_at(index) if index
					  # only continue if owner was not only subscriber
					  if message.bcc.provided?
  						message.locale = locale
						  message.subject = I18n.t("mailer.notification.new_idea_subscriber.subject", :locale => locale)
						  message.message = I18n.t("mailer.notification.new_idea_subscriber.message", :locale => locale)
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
