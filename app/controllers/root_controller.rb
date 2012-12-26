class RootController < ApplicationController

  def index
    @visualizations = Visualization.published.recent.page(params[:page])

		if params[:type]
			type_id = Visualization.type_id(params[:type])
			@visualizations = @visualizations.by_type(type_id) if type_id
		end


    respond_to do |format|
      format.html
      format.js {render 'shared/index'}
    end
  end

	def about
    @page = Page.where(:name => "about").first
	end

	def data
    @page = Page.where(:name => "data").first
	end

	def get_involved
    @page = Page.where(:name => "get_involved").first
	end

	def snapshot
		@kit = IMGKit.new(params[:url])

    respond_to do |format|
			format.png do
				send_data(@kit.to_png, :type => "image/png", :disposition => 'inline')
			end
    end
	end


end
