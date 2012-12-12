class RootController < ApplicationController

  def index
    @stories = Story.published.recent
  end

  def story
    @story = Story.published.find(params[:id])
  end

end
