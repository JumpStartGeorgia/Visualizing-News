class StoryObserver < ActiveRecord::Observer

	def after_create(story)
		story.is_create = true
	end

	# after story has been created, send notification
	def after_commit(story)
		# only process if a create just occurred
		if story.is_create
			message = Message.new
			message.subject = I18n.t("mailer.story.new_story.subject")
			message.message = I18n.t("mailer.story.new_story.message")
			NotificationMailer.new_story(message).deliver
		end
	end
end
