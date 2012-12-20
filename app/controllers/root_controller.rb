class RootController < ApplicationController

  def index
    @stories = Story.published.recent.page(params[:page])

    if params[:view] && params[:view] == 'list'
      @view_type = 'visuals/list'
    else
      @view_type = 'visuals/grid'
    end

    respond_to do |format|
      format.html
      format.js
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

end
