class User < ActiveRecord::Base
	has_many :notifications, :dependent => :destroy
	has_many :organization_users, :dependent => :destroy
	has_many :organizations, :through => :organization_users
	has_many :ideas
	has_many :idea_inappropriate_reports
  accepts_nested_attributes_for :organization_users

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	# :registerable, :recoverable,
  devise :database_authenticatable,:registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
		:role, :provider, :uid, :nickname, :avatar, :organization_ids, :wants_notifications, :notification_language, :db_migrate, :permalink
	attr_accessor :send_notification, :db_migrate

  validates :email, :nickname, :presence => true
	before_save :create_permalink
	before_save :check_for_role
	before_save :set_notification_language

	default_scope includes(:organizations)

  def self.no_admins
    where("role != ?", ROLES[:admin])
  end

  # use role inheritence
  # - a role with a larger number can do everything that smaller numbers can do
  ROLES = {:user => 0, :org_admin => 50, :visual_promotion => 75, :admin => 99}
  def role?(base_role)
    if base_role && ROLES.values.index(base_role)
      return base_role <= self.role
    end
    return false
  end

  def role_name
    ROLES.keys[ROLES.values.index(self.role)].to_s
  end

	def create_permalink
		self.permalink = self.nickname.downcase.gsub('.', '-').gsub(/[^0-9A-Za-z_\- ]/,'').split.join('_')
	end

	# if no role is supplied, default to the basic user role
	def check_for_role
		self.role = User::ROLES[:user] if self.role.nil?
	end

	# if not set, default to current locale
	def set_notification_language
		self.notification_language = I18n.locale if self.notification_language.nil?
	end

	def organization_ids
		ids = []
		if !self.organization_users.empty?
			ids = self.organization_users.map{|x| x.organization_id}
		end
		return ids
	end

	def is_following_idea?(idea_id)
		if idea_id
			x = Notification.where(:user_id => self.id,
														:notification_type => Notification::TYPES[:follow_idea],
														:identifier => idea_id)
			if x && !x.empty?
				return true
			end
		end
	end

	##############################
	## omniauth methods
	##############################
	# get user credentials from omniauth
	def self.from_omniauth(auth)
		x = where(auth.slice(:provider, :uid)).first
		if x.nil?
			x = User.create(:provider => auth.provider, :uid => auth.uid,
											:email => auth.info.email,
											:nickname => auth.info.nickname, :avatar => auth.info.image)
		end
		return x
	end

	# if login fails with omniauth, sessions values are populated with
	# any data that is returned from omniauth
	# this helps load them into the new user registration url
	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], :without_protection => true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	# if user logged in with omniauth, password is not required
	def password_required?
		super && provider.blank?
	end
end
