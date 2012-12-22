class NotificationsController < ApplicationController
  before_filter :authenticate_user!

	def index
		gon.notifications = true
		msg = []

		if request.post?
			if params[:enable_notifications] && params[:enable_notifications] == 'true'
				# make sure user is marked as wanting notifications
				if !current_user.wants_notifications
					current_user.wants_notifications = true
					current_user.save
					msg << I18n.t('app.msgs.notification_yes')
				end

				if params[:none]
					# delete all notifications
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					msg << I18n.t('app.msgs.notification_new_idea_none_success')
				elsif params[:all]
					# all notifications
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					# add all option
					Notification.create(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id)

					msg << I18n.t('app.msgs.notification_new_idea_all_success')
				elsif params[:categories] && !params[:categories].empty?
					# by category
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					# add each category
					params[:categories].each do |cat_id|
						Notification.create(:notification_type => Notification::TYPES[:new_idea],
																						:user_id => current_user.id,
																						:identifier => cat_id)
					end
					msg << I18n.t('app.msgs.notification_new_idea_by_category_success',
						:categories => @categories.select{|x| params[:categories].index(x.id.to_s)}.map{|x| x.name}.join(","))

				end
			else
				# indicate user does not want notifications
				if current_user.wants_notifications
					current_user.wants_notifications = false
					current_user.save
				end

				# delete any on record
				Notification.where(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id).delete_all

				msg << I18n.t('app.msgs.notification_no')
			end
		end

		# see if user wants notifications
		@enable_notifications = current_user.wants_notifications
		gon.enable_notifications = @enable_notifications

		# get data to load the form
		@notifications = Notification.where(:notification_type => Notification::TYPES[:new_idea],
																			:user_id => current_user.id)

		@all = false
		@none = false

		if @notifications && !@notifications.empty?
			if @notifications.length == 1 && @notifications.first.identifier.nil?
				@all = true
			end
		else
			@none = true
		end

		flash[:notice] = msg.join("<br />") if !msg.empty?
	end

end
