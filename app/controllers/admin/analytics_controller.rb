class Admin::AnalyticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:analytics])
  end

  def index
    @visualizations = Visualization.with_translations
  end
end
