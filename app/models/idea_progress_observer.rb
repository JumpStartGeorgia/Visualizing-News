class IdeaProgressObserver < ActiveRecord::Observer

	def after_create(idea_progress)
		if !idea_progress.is_private
			idea_progress.is_create = true

			# update idea status value to be this one
	Rails.logger.debug "===== idea prog create obs"
			i = Idea.find_by_id(idea_progress.idea_id)
			if i
	Rails.logger.debug "====== saving new status to idea"
				i.current_status_id = idea_progress.idea_status_id
				i.save
			end
		end
	end


	# after an idea progress has been saved, notify the owner and subscribers
	def after_commit(idea_progress)
		# only process if a create just occurred
		# - see after_create method above
		if idea_progress.is_create
			# determine if idea is realized
			if idea_progress.is_completed && idea_progress.url
				# idea realized

				# notify owner if wants notification
				if idea_progress.idea.user.wants_notifications
					message = Message.new
					message.email = idea_progress.idea.user.email
					message.subject = I18n.t("mailer.owner.idea_realized.subject",
															:organization => idea_progress.organization.name)
					message.message = I18n.t("mailer.owner.idea_realized.message",
															:organization => idea_progress.organization.name)
					message.org_message = idea_progress.explaination
					message.url = idea_progress.url
					NotificationOwnerMailer.idea_realized(message).deliver
				end

				# notify subscribers
				message = Message.new
				message.bcc = Notification.follow_idea_users(idea_progress.idea_id)
				if message.bcc && !message.bcc.empty?
					# if the owner is a subscriber, remove from list
					index = message.bcc.index(idea_progress.idea.user.email)
					message.bcc.delete_at(index) if index
					# only continue if owner was not only subscriber
					if message.bcc.length > 0
						message.subject = I18n.t("mailer.subscriber.idea_realized.subject",
																:organization => idea_progress.organization.name)
						message.message = I18n.t("mailer.subscriber.idea_realized.message",
																:organization => idea_progress.organization.name)
						message.org_message = idea_progress.explaination
						message.url = idea_progress.url
						NotificationSubscriberMailer.idea_realized(message).deliver
					end
				end
			else
				# see if this idea is already claimed by this org
				ideas = IdeaProgress.where("idea_id = ? and organization_id = ? and id != ?",
					idea_progress.idea_id, idea_progress.organization_id, idea_progress.id)

				if ideas && !ideas.empty?
					# org already claimed, just an update
					# notify owner if wants notification
					if idea_progress.idea.user.wants_notifications
						message = Message.new
						message.email = idea_progress.idea.user.email
						message.subject = I18n.t("mailer.owner.idea_progress_update.subject",
																:organization => idea_progress.organization.name)
						message.message = I18n.t("mailer.owner.idea_progress_update.message",
																:organization => idea_progress.organization.name)
						message.org_message = idea_progress.explaination
						message.url_id = idea_progress.idea_id
						NotificationOwnerMailer.idea_progress_update(message).deliver
					end

					# notify subscribers
					message = Message.new
					message.bcc = Notification.follow_idea_users(idea_progress.idea_id)
					if message.bcc && !message.bcc.empty?
						# if the owner is a subscriber, remove from list
						index = message.bcc.index(idea_progress.idea.user.email)
						message.bcc.delete_at(index) if index
						# only continue if owner was not only subscriber
						if message.bcc.length > 0
							message.subject = I18n.t("mailer.subscriber.idea_progress_update.subject",
																	:organization => idea_progress.organization.name)
							message.message = I18n.t("mailer.subscriber.idea_progress_update.message",
																	:organization => idea_progress.organization.name)
							message.org_message = idea_progress.explaination
							message.url_id = idea_progress.idea_id
							NotificationSubscriberMailer.idea_progress_update(message).deliver
						end
					end
				else
					# org is claiming idea
					# notify owner if wants notification
					if idea_progress.idea.user.wants_notifications
						message = Message.new
						message.email = idea_progress.idea.user.email
						message.subject = I18n.t("mailer.owner.idea_claimed.subject",
																:organization => idea_progress.organization.name)
						message.message = I18n.t("mailer.owner.idea_claimed.message",
																:organization => idea_progress.organization.name)
						message.org_message = idea_progress.explaination
						message.url_id = idea_progress.idea_id
						NotificationOwnerMailer.idea_claimed(message).deliver
					end

					# notify subscribers
					message = Message.new
					message.bcc = Notification.follow_idea_users(idea_progress.idea_id)
					if message.bcc && !message.bcc.empty?
						# if the owner is a subscriber, remove from list
						index = message.bcc.index(idea_progress.idea.user.email)
						message.bcc.delete_at(index) if index
						# only continue if owner was not only subscriber
						if message.bcc.length > 0
							message.subject = I18n.t("mailer.subscriber.idea_claimed.subject",
																	:organization => idea_progress.organization.name)
							message.message = I18n.t("mailer.subscriber.idea_claimed.message",
																	:organization => idea_progress.organization.name)
							message.org_message = idea_progress.explaination
							message.url_id = idea_progress.idea_id
							NotificationSubscriberMailer.idea_claimed(message).deliver
						end
					end
				end
			end
		end

	end
end
