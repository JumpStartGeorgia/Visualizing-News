####################
# /visualizations/....
# this controller is the public view to the visuals
####################
class VisualsController < ApplicationController

  def index
    @visualizations = Visualization.published.recent.page(params[:page])

    process_visualization_querystring # in app controller

    respond_to do |format|
      format.atom
      format.html
      format.js {
        @ajax_call = true
        render 'shared/index'
      }
    end
	end

  def show
    @visualization = Visualization.published.find_by_permalink(params[:id])

		if @visualization
			if @visualization.visualization_type_id == Visualization::TYPES[:interactive] && params[:view] == 'interactive'
			  @view_type = 'shared/show_interactive'
				gon.show_interactive = true
			else
			  @view_type = 'shared/show'
			end

			gon.show_fb_comments = true

      # if from_embed in url, set gon so large image loads automatically
      if params[:from_embed] && @visualization.visualization_type_id == Visualization::TYPES[:infographic]
        gon.trigger_fancybox_large_image = true
      end

			respond_to do |format|
			  format.html
			  format.json { render json: @visualization }
			end
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path(:locale => I18n.locale)
		end
  end

  def vote
		redirect_path = if request.env["HTTP_REFERER"]
	    :back
		else
	    root_path
		end

    if !(['down', 'up'].include? params[:status])
      redirect_to redirect_path
      return
    end

    visualization = Visualization.published.find_by_permalink(params[:id])

    if !visualization
      redirect_to redirect_path
      return
    end

    ip = request.remote_ip
    record = VoterIp.where(:ip => ip, :votable_type => visualization.class.name.downcase, :votable_id => visualization.id)

    if record.nil? || record.empty?

      if visualization.individual_votes.nil? || visualization.individual_votes.length < 4
        visualization.individual_votes = '+0-0'
      end

      split = visualization.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
      elsif params[:status] == 'down'
        downs = downs + 1
      end

      visualization.individual_votes = "+#{ups}-#{downs}"
			visualization.overall_votes = ups - downs
      visualization.save

      VoterIp.create(:ip => ip, :votable_type => visualization.class.name.downcase,
                      :votable_id => visualization.id, :status => params[:status])

    elsif record[0].status != params[:status]

      split = visualization.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
        downs = downs - 1
      elsif params[:status] == 'down'
        ups = ups - 1
        downs = downs + 1
      end

      visualization.individual_votes = "+#{ups}-#{downs}"
			visualization.overall_votes = ups - downs
      visualization.save

      record[0].status = params[:status]
      record[0].save
    else
	    redirect_to redirect_path
      return false
    end

    redirect_to redirect_path
  end

  def next
    next_previous('next')
  end

  def previous
    next_previous('previous')
  end

	def comment_notification
    visualization = Visualization.published.find_by_permalink(params[:id])
		if visualization
      # notify org users if want notification
			message = Message.new
			I18n.available_locales.each do |locale|
				message.bcc = Notification.visual_comment(visualization.organization_id, locale)
				if message.bcc && !message.bcc.empty?
					message.locale = locale
					message.subject = I18n.t("mailer.notification.visualization_comment.subject",
						:title => visualization.title, :locale => locale)
					message.message = I18n.t("mailer.notification.visualization_comment.message", :locale => locale)
					message.url_id = visualization.permalink
					NotificationMailer.visualization_comment(message).deliver
				end
			end

			render :text => "true"
			return false
		end
		render :text => "false"
		return false
	end

protected

  def next_previous(type)
		# get a list of visual ids in correct order
    visualizations = Visualization.select("visualizations.id").published.recent
    # get the visual that was showing
    visualization = Visualization.published.find_by_permalink(params[:id])
		record_id = nil

		if visualizations && !visualizations.empty? && visualization
			index = visualizations.index{|x| x.id == visualization.id}
      if type == 'next'
  			if index
  				if index == visualizations.length-1
  					record_id = visualizations[0].id
  				else
  					record_id = visualizations[index+1].id
  				end
  			else
  				record_id = visualizations[0].id
  			end
  		elsif type == 'previous'
				if index
					if index == 0
						record_id = visualizations[visualizations.length-1].id
					else
						record_id = visualizations[index-1].id
					end
				else
					record_id = visualizations[0].id
				end
			end

			if record_id
  			# get the next record
  			visual = Visualization.published.find_by_id(record_id)

  			if visual
  			  # found next record, go to it
          redirect_to visualization_path(visual.permalink)
          return
  	    end
      end
    end

		# if get here, then next record was not found
    redirect_to(visuals_path, :alert => t("app.common.page_not_found"))
    return
  end
end
