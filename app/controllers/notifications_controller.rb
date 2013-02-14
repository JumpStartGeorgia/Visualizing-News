class NotificationsController < ApplicationController
#  before_filter :authenticate_user!

	def index
		gon.notifications = true
		msg = []
    if user_signed_in?
  		if request.post?
  			if params[:enable_notifications] && params[:enable_notifications] == 'true'
  				# make sure user is marked as wanting notifications
  				if !current_user.wants_notifications
  					current_user.wants_notifications = true
  					current_user.save
  					msg << I18n.t('app.msgs.notification_yes')
  				end

					# language
					if params[:language]
  					current_user.notification_language = params[:language]
  					current_user.save
  					msg << I18n.t('app.msgs.notification_language', :language => t("app.language.#{params[:language]}"))
					end

          # process visualization notifications
  				if params[:visuals_all]
  					# all notifications
  					# delete anything on file first
  					Notification.where(:notification_type => Notification::TYPES[:new_visual],
  																					:user_id => current_user.id).delete_all
  					# add all option
  					Notification.create(:notification_type => Notification::TYPES[:new_visual],
  																					:user_id => current_user.id)

  					msg << I18n.t('app.msgs.notification_new_visual_all_success')
  				elsif params[:visuals_categories].present?
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
  				else
  					# delete all notifications
  					Notification.where(:notification_type => Notification::TYPES[:new_visual],
  																					:user_id => current_user.id).delete_all
  					msg << I18n.t('app.msgs.notification_new_visual_none_success')
          end

					# process visual comment notifications for each org
					if params[:visual_comment]
						params[:visual_comment].keys.each do |org_id|
							existing = Notification.where(:notification_type => Notification::TYPES[:visual_comment],
																							:user_id => current_user.id)

							if params[:visual_comment][org_id][:wants] == "true" && existing.empty?
								Notification.create(:notification_type => Notification::TYPES[:visual_comment],
																								:user_id => current_user.id,
																								:identifier => org_id)

								msg << I18n.t('app.msgs.notification_visual_comments_yes',
									:org => params[:visual_comment][org_id][:name])
							elsif params[:visual_comment][org_id][:wants] != "true" && !existing.empty?
								# delete anything on file first
								existing.delete_all
								msg << I18n.t('app.msgs.notification_visual_comments_no',
									:org => params[:visual_comment][org_id][:name])
							end
						end
					end

          # process idea notificatons
  				if params[:ideas_all]
  					# all notifications
  					# delete anything on file first
  					Notification.where(:notification_type => Notification::TYPES[:new_idea],
  																					:user_id => current_user.id).delete_all
  					# add all option
  					Notification.create(:notification_type => Notification::TYPES[:new_idea],
  																					:user_id => current_user.id)

  					msg << I18n.t('app.msgs.notification_new_idea_all_success')
  				elsif params[:ideas_categories].present?
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

  				else
  					# delete all notifications
  					Notification.where(:notification_type => Notification::TYPES[:new_idea],
  																					:user_id => current_user.id).delete_all
  					msg << I18n.t('app.msgs.notification_new_idea_none_success')
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

			# get the notfification language
			@language = current_user.notification_language.nil? ? I18n.default_locale.to_s : current_user.notification_language

  		# get new visual data to load the form
  		@visual_notifications = Notification.where(:notification_type => Notification::TYPES[:new_visual],
  																			:user_id => current_user.id)

  		@visual_all = false

  		if @visual_notifications.present? && @visual_notifications.length == 1 && @visual_notifications.first.identifier.nil?
				@visual_all = true
  		end

			# get visual comments for each org
			if !current_user.organization_users.empty?
				@visual_comment = Hash.new
				current_user.organizations.each do |org|
					comment_notify = Notification.where(:notification_type => Notification::TYPES[:visual_comment],
  																			:user_id => current_user.id,
  																			:identifier => org.id)
					@visual_comment[org.id] = comment_notify && !comment_notify.empty? ? true : false
				end
			end


  		# get new idea data to load the form
  		@idea_notifications = Notification.where(:notification_type => Notification::TYPES[:new_idea],
  																			:user_id => current_user.id)

  		@idea_all = false

  		if @idea_notifications.present? && @idea_notifications.length == 1 && @idea_notifications.first.identifier.nil?
				@idea_all = true
  		end

  		flash[:notice] = msg.join("<br />").html_safe if !msg.empty?
  	end
	end

end
