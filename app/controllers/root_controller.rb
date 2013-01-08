class RootController < ApplicationController

  def index
    @visualizations = Visualization.published.recent.page(params[:page])

    process_visualization_querystring # in app controller

    respond_to do |format|
      format.html
      format.js {
        @ajax_call = true
        render 'shared/index'
      }
    end
  end

	def about
    @page = Page.where(:name => "about").first
	end

	def data
    @page = Page.where(:name => "data").first
	end

	def submit_visual
    @page = Page.where(:name => "submit_visual").first
	end

	def terms
    @page = Page.where(:name => "terms").first
	end

	def snapshot
		@kit = IMGKit.new(params[:url])

    respond_to do |format|
			format.png do
				send_data(@kit.to_png, :type => "image/png", :disposition => 'inline')
			end
    end
	end

	def rss
	end


end
