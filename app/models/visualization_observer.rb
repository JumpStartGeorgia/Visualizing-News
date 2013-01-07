class VisualizationObserver < ActiveRecord::Observer

	def after_save(visualization)
		# set flag to true if the published flag is true and the record was not published before
		visualization.send_notification = true if visualization.published && !visualization.was_published
Rails.logger.debug("///////////////// send notification = #{visualization.send_notification}")
	end

	# after visualization has been created, send notification
	def after_commit(visualization)
Rails.logger.debug("///////////////// sending notification = #{visualization.send_notification}")
		if visualization.send_notification
			message = Message.new
Rails.logger.debug("///////////////// getting category ids")
			category_ids = visualization.visualization_categories.map{|x| x.category_id}
Rails.logger.debug("///////////////// category ids = #{category_ids}")
			if category_ids && !category_ids.empty?
				message = Message.new
Rails.logger.debug("///////////////// getting emails to send to")
				message.bcc = Notification.new_visual(category_ids)
				if message.bcc && !message.bcc.empty?
Rails.logger.debug("///////////////// sending email")
					message.subject = I18n.t("mailer.notification.new_visualization.subject")
					message.message = I18n.t("mailer.notification.new_visualization.message", :title => visualization.title)
					message.url_id = visualization.permalink
					NotificationMailer.new_visualization(message).deliver
Rails.logger.debug("///////////////// sending email done")
				end
			end
		end
	end
end
