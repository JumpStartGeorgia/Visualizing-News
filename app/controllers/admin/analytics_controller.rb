class Admin::AnalyticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:analytics])
  end

  def index
    @visualizations = Visualization.published.with_translations

    @visualization_types = Visualization.select('visualizations.visualization_type_id AS id, visualizations.languages, SUM(visualizations.impressions_count) AS impressions_count, SUM(visualizations.fb_likes) AS fb_likes, SUM(visualizations.overall_votes) AS overall_votes').group(:visualization_type_id)
  end
end
