class VisualizationObserver < ActiveRecord::Observer

	def after_save(visualization)
		visualization.is_create = true if visualization.published
	end

	# after visualization has been created, send notification
	def after_commit(visualization)
		# only process if a create just occurred
		if visualization.is_create
			message = Message.new
			message.subject = I18n.t("mailer.visualization.new_visualization.subject")
			message.message = I18n.t("mailer.visualization.new_visualization.message")
			NotificationMailer.new_visualization(message).deliver
		end
	end
end
