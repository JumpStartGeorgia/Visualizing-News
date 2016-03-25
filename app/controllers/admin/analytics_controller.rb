class Admin::AnalyticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:analytics])
  end

  def index
    @visualizations = Visualization.published.with_translations

    # No way to SUM multiple columns in ActiveRecord query language
    @categories = Visualization.select('category_translations.name AS name, visualizations.languages, SUM(visualizations.impressions_count) AS impressions_count, SUM(visualizations.fb_likes) AS fb_likes, SUM(visualizations.overall_votes) AS overall_votes').joins(categories: :category_translations).where("category_translations.locale = '#{I18n.locale}'").group('name')

    @visualization_types = Visualization.select('visualizations.visualization_type_id, visualizations.languages, SUM(visualizations.impressions_count) AS impressions_count, SUM(visualizations.fb_likes) AS fb_likes, SUM(visualizations.overall_votes) AS overall_votes').group(:visualization_type_id)
  end
end
