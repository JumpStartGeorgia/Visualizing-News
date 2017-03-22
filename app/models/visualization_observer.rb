class VisualizationObserver < ActiveRecord::Observer

	def after_save(visualization)
		# set flag to true if the published flag is true and the record was not published before
		visualization.send_notification = visualization.published && !visualization.was_published && Rails.env.production?
    # Rails.logger.debug "====== vis send notification = #{visualization.send_notification}"
	end

	# after visualization has been created, send notification
	def after_commit(visualization)
    # Rails.logger.debug "===== after commit"
		if visualization.send_notification
      users = []  

      # if visual is not promoted, send notification
      if !visualization.is_promoted
    # Rails.logger.debug "===== - promote email"
			  message = Message.new
        users = User.visual_promotion_users
			  I18n.available_locales.each do |locale|
				  message.bcc = users.select{|x| x.notification_language == locale.to_s}.map{|x| x.email}
				  if message.bcc.length > 0
					  message.locale = locale
            trans = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first
            if trans.present?
						  message.subject = I18n.t("mailer.notification.new_visualization_needs_promotion.subject", :locale => locale)
						  message.message = I18n.t("mailer.notification.new_visualization_needs_promotion.message", :title => trans.title, :locale => locale)
						  message.org_message = trans.explanation
						  message.url_id = trans.permalink
						  NotificationMailer.new_visualization_needs_promotion(message).deliver
					  end
				  end
			  end
		  end

			category_ids = visualization.visualization_categories.map{|x| x.category_id}
			if category_ids && !category_ids.empty?
    # Rails.logger.debug "===== - categories"
				message = Message.new
				I18n.available_locales.each do |locale|
					message.bcc = Notification.new_visual(category_ids, locale)
					if message.bcc.length > 0
  				  # if the email is of user that got sent needs promotion email, remove from list
            users.each do |user|
				      index = message.bcc.index(user.email)
				      message.bcc.delete_at(index) if index
            end

					  if message.bcc.length > 0
						  message.locale = locale
              trans = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first
              if trans.present?
							  message.subject = I18n.t("mailer.notification.new_visualization.subject", :locale => locale)
							  message.message = I18n.t("mailer.notification.new_visualization.message", :title => trans.title, :locale => locale)
							  message.org_message = trans.explanation
							  message.url_id = trans.permalink
							  NotificationMailer.new_visualization(message).deliver
						  end
  					end
					end
				end
			end

		end
	end
end
