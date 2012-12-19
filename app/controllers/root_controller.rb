class RootController < ApplicationController

  def index
    @stories = Story.published.recent
    
    if params[:view] && params[:view] == 'list'
      @view_type = 'visuals/list'
    else
      @view_type = 'visuals/grid'
    end
  end

end
