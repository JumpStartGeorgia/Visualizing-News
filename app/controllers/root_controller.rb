class RootController < ApplicationController

  def index
    gon.ajax_path = visualizations_ajax_path(:format => :js, :max => 4, :sidebar => true, :promoted => true)

    set_visualization_view_type # in app controller

	end

	def about
    @page = Page.where(:name => "about").first
	end

	def data
    @page = Page.where(:name => "data").first
    @message = Message.new
    if request.post?
      @message = Message.new(params[:message])
      if @message.valid?
        # send message
  			ContactMailer.send_data(@message).deliver
  			@email_sent = true
      end
    end
	end

	def submit_visual
    @page = Page.where(:name => "submit_visual").first
    @message = Message.new
    if request.post?
      @message = Message.new(params[:message])
      if @message.valid?
        # send message
  			ContactMailer.submit_visual(@message).deliver
  			@email_sent = true
      end
    end
	end

  def contact
    @message = Message.new
    if request.post?
		  @message = Message.new(params[:message])
		  if @message.valid?
		    # send message
				ContactMailer.new_message(@message).deliver
				@email_sent = true
		  end
	  end
    respond_to do |format|
      format.html { render :layout => 'fancybox'}
     #format.json { render json: @idea }
    end
  end

	def terms
    @page = Page.where(:name => "terms").first
	end

	def rss
	end


  # method for deleting queued_like cookie on server-side
  # javascript fails to unset cookie for some reason
  def unset_cookie
    cookies.delete :queued_like
    render :nothing => true
  end


end
