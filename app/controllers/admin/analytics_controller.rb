class Admin::AnalyticsController < ApplicationController
  def index
    @visualizations = Visualization.with_translations
  end
end
