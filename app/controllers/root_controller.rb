class RootController < ApplicationController

  def index
    @stories = Story.published.recent
  end

  def story
    @story = Story.published.find(params[:id])
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
    when 'story'
      m = Story
    else
      redirect_to root_path, :alert => 'wrong votable'
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
end
