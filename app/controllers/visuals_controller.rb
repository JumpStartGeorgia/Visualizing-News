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
      redirect_to redirect_path, :alert => 'wrong status'
      return
    end

    case params[:type]
    when 'comment'
      m = Comment
    when 'visualization'
      m = Visualization
    else
      redirect_to root_path(:locale => I18n.locale), :alert => t('app.msgs.does_not_exist')
      return
    end

    ip = request.remote_ip
    record = VoterIp.where(:ip => ip, :votable_type => params[:type], :votable_id => params[:votable_id])

    if record.nil? || record.empty?

      obj = m.find(params[:votable_id])
      if obj.individual_votes.nil? || obj.individual_votes.length < 4
        obj.individual_votes = '+0-0'
      end

      split = obj.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
      elsif params[:status] == 'down'
        downs = downs + 1
      end

      obj.individual_votes = '+' + ups.to_s + '-' + downs.to_s
			obj.overall_votes = ups - downs
      obj.save

      VoterIp.create(:ip => ip, :votable_type => params[:type], :votable_id => params[:votable_id], :status => params[:status])

    elsif record[0].status != params[:status]

      obj = m.find(params[:votable_id])

      split = obj.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
        downs = downs - 1
      elsif params[:status] == 'down'
        ups = ups - 1
        downs = downs + 1
      end

      obj.individual_votes = '+' + ups.to_s + '-' + downs.to_s
			obj.overall_votes = ups - downs
      obj.save

      record[0].status = params[:status]
      record[0].save
    else
	    redirect_to redirect_path
      return false
    end

    redirect_to redirect_path
  end
  
	def comment_notification
    visualization = Visualization.published.find_by_permalink(params[:id])
		if visualization
      # notify org users if wants noticication

=begin
			# notify owner if wants notification
			if idea.user.wants_notifications
				message = Message.new
				message.email = idea.user.email
				message.subject = I18n.t('mailer.owner.new_comment.subject')
				message.message = I18n.t('mailer.owner.new_comment.message')
				message.url_id = params[:idea_id]
				NotificationOwnerMailer.new_comment(message).deliver
			end

=end
			render :text => "true"
			return false
		end
		render :text => "false"
		return false
	end
  
end
