class RootController < ApplicationController

  def index

#    @visualizations = process_visualization_querystring(Visualization.published.page(params[:page]).per(6))
    gon.vis_ajax_path = root_path(:format => :js)
   #@visualizations = Visualization.published.recent.page(1)

    process_visualization_querystring # in app controller

    respond_to do |format|
      format.html
      format.js {
        @ajax_call = true
        render 'shared/visuals_index'
      }
    end
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
  end

	def terms
    @page = Page.where(:name => "terms").first
	end

	def rss
	end


end
