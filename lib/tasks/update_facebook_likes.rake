require 'update_facebook_likes'

namespace :facebook_update do

	##############################
  desc "update the visual facebook like counts"
  task :visuals => [:environment] do

    UpdateFacebookLikes.visuals
  end

	##############################
  desc "update the idea facebook like counts"
  task :ideas => [:environment] do

    UpdateFacebookLikes.ideas
  end

end
