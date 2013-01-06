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

        # process visualization notifications
				if params[:visuals_none]
					# delete all notifications
					Notification.where(:notification_type => Notification::TYPES[:new_visual],
																					:user_id => current_user.id).delete_all
					msg << I18n.t('app.msgs.notification_new_visual_none_success')
				elsif params[:visuals_all]
					# all notifications
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_visual],
																					:user_id => current_user.id).delete_all
					# add all option
					Notification.create(:notification_type => Notification::TYPES[:new_visual],
																					:user_id => current_user.id)

					msg << I18n.t('app.msgs.notification_new_visual_all_success')
				elsif params[:visuals_categories] && !params[:visuals_categories].empty?
					# by category
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_visual],
																					:user_id => current_user.id).delete_all
					# add each category
					params[:visuals_categories].each do |cat_id|
						Notification.create(:notification_type => Notification::TYPES[:new_visual],
																						:user_id => current_user.id,
																						:identifier => cat_id)
					end
					msg << I18n.t('app.msgs.notification_new_visual_by_category_success',
						:categories => @categories.select{|x| params[:visuals_categories].index(x.id.to_s)}.map{|x| x.name}.join(", "))
        end
        
        # process idea notificatons
				if params[:ideas_none]
					# delete all notifications
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					msg << I18n.t('app.msgs.notification_new_idea_none_success')
				elsif params[:ideas_all]
					# all notifications
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					# add all option
					Notification.create(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id)

					msg << I18n.t('app.msgs.notification_new_idea_all_success')
				elsif params[:ideas_categories] && !params[:ideas_categories].empty?
					# by category
					# delete anything on file first
					Notification.where(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id).delete_all
					# add each category
					params[:ideas_categories].each do |cat_id|
						Notification.create(:notification_type => Notification::TYPES[:new_idea],
																						:user_id => current_user.id,
																						:identifier => cat_id)
					end
					msg << I18n.t('app.msgs.notification_new_idea_by_category_success',
						:categories => @categories.select{|x| params[:ideas_categories].index(x.id.to_s)}.map{|x| x.name}.join(", "))

				end
				
			else
				# indicate user does not want notifications
				if current_user.wants_notifications
					current_user.wants_notifications = false
					current_user.save
				end

				# delete any on record
				Notification.where(:notification_type => Notification::TYPES[:new_visual],
																				:user_id => current_user.id).delete_all
				Notification.where(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id).delete_all

				msg << I18n.t('app.msgs.notification_no')
			end
		end

		# see if user wants notifications
		@enable_notifications = current_user.wants_notifications
		gon.enable_notifications = @enable_notifications

		# get new visual data to load the form
		@visual_notifications = Notification.where(:notification_type => Notification::TYPES[:new_visual],
																			:user_id => current_user.id)

		@visual_all = false
		@visual_none = false

		if @visual_notifications && !@visual_notifications.empty?
			if @visual_notifications.length == 1 && @visual_notifications.first.identifier.nil?
				@visual_all = true
			end
		else
			@visual_none = true
		end

		# get new idea data to load the form
		@idea_notifications = Notification.where(:notification_type => Notification::TYPES[:new_idea],
																			:user_id => current_user.id)

		@idea_all = false
		@idea_none = false

		if @idea_notifications && !@idea_notifications.empty?
			if @idea_notifications.length == 1 && @idea_notifications.first.identifier.nil?
				@idea_all = true
			end
		else
			@idea_none = true
		end

		flash[:notice] = msg.join("<br />").html_safe if !msg.empty?
	end

end
