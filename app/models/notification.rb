class Notification < ActiveRecord::Base
	belongs_to :user

  attr_accessible :user_id, :notification_type, :identifier
	attr_accessible :email

  validates :user_id, :notification_type, :presence => true

  TYPES = {:new_idea => 1, :follow_idea => 2, :new_visual => 3}

=begin
	def self.new_idea_users(category_ids)
		x = nil
		if category_ids
			if category_ids.class == Array
				if !category_ids.empty?
					# idea belongs to multiple categories
					x = select("users.email").joins(:user)
					.where("users.wants_notifications = 1 and notification_type = ? and (identifier is null or identifier in (?))", TYPES[:new_idea], category_ids)
				end
			else
				# idea belongs to one category
				x = select("users.email").joins(:user)
				.where("users.wants_notifications = 1 and notification_type = ? and (identifier is null or identifier = ?)", TYPES[:new_idea], category_ids)
			end

			if x && !x.empty?
				x = x.map{|x| x.email}
			end
		end
		return x
	end

	def self.follow_idea_users(idea_id)
		x = nil
		if idea_id
			x = select("users.email").joins(:user)
			.where("users.wants_notifications = 1 and notification_type = ? and identifier = ?", TYPES[:follow_idea], idea_id)

			if x && !x.empty?
				x = x.map{|x| x.email}
			end
		end
		return x
	end
=end
end
