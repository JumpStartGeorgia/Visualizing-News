class Notification < ActiveRecord::Base
	belongs_to :user

  attr_accessible :user_id, :notification_type, :identifier
	attr_accessible :email

  validates :user_id, :notification_type, :presence => true

  TYPES = {:new_idea => 1, :follow_idea => 2, :new_visual => 3, :visual_comment => 4}

	def self.new_visual(category_ids, locale)
		return new_item(TYPES[:new_visual], category_ids, locale)
	end

	def self.visual_comment(organization_id, locale)
		x = nil
		if organization_id && locale
			x = select("users.email").joins(:user)
			.where("users.wants_notifications = 1 and users.notification_language = ? and notification_type = ? and identifier = ?",
				 locale, TYPES[:visual_comment], organization_id)

			if x && !x.empty?
				x = x.map{|x| x.email}
			end
		end
		return x
	end

	def self.new_idea_users(category_ids, locale)
		return new_item(TYPES[:new_idea], category_ids, locale)
	end

	def self.follow_idea_users(idea_id, locale)
		x = nil
		if idea_id && locale
			x = select("users.email").joins(:user)
			.where("users.wants_notifications = 1 and users.notification_language = ? and notification_type = ? and identifier = ?", locale, TYPES[:follow_idea], idea_id)

			if x && !x.empty?
				x = x.map{|x| x.email}
			end
		end
		return x
	end

protected

	def self.new_item(type, category_ids, locale)
		x = nil
		if category_ids && type && locale
			if category_ids.class == Array
				if !category_ids.empty?
					# visual belongs to multiple categories
					x = select("users.email").joins(:user)
					.where("users.wants_notifications = 1 and users.notification_language = ? and notification_type = ? and (identifier is null or identifier in (?))", locale, type, category_ids)
				end
			else
				# visual belongs to one category
				x = select("users.email").joins(:user)
				.where("users.wants_notifications = 1 and users.notification_language = ? and notification_type = ? and (identifier is null or identifier = ?)", locale, type, category_ids)
			end

			if x && !x.empty?
				x = x.map{|x| x.email}
			end
		end
		return x
	end

end
