class VisualizationObserver < ActiveRecord::Observer

	def after_save(visualization)
		# set flag to true if the published flag is true and the record was not published before
		visualization.send_notification = true if visualization.published && !visualization.was_published
	end

	# after visualization has been created, send notification
	def after_commit(visualization)
		if visualization.send_notification
			message = Message.new
			message.subject = I18n.t("mailer.visualization.new_visualization.subject")
			message.message = I18n.t("mailer.visualization.new_visualization.message")
			NotificationMailer.new_visualization(message).deliver
		end
	end
end
