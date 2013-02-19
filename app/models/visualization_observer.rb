class VisualizationObserver < ActiveRecord::Observer

	def after_save(visualization)
		# set flag to true if the published flag is true and the record was not published before
		visualization.send_notification = true if visualization.published && !visualization.was_published
	end

	# after visualization has been created, send notification
	def after_commit(visualization)
		if visualization.send_notification
			message = Message.new
			category_ids = visualization.visualization_categories.map{|x| x.category_id}
			if category_ids && !category_ids.empty?
				message = Message.new
				I18n.available_locales.each do |locale|
					message.bcc = Notification.new_visual(category_ids, locale)
					if message.bcc.provided?
						message.locale = locale
            title = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first.title
						message.subject = I18n.t("mailer.notification.new_visualization.subject", :locale => locale)
						message.message = I18n.t("mailer.notification.new_visualization.message",
							:title => title, :locale => locale)
						message.url_id = visualization.visualization_translations.select{|x| x.locale == locale.to_s}.first.permalink
						NotificationMailer.new_visualization(message).deliver
					end
				end
			end
		end
	end
end
