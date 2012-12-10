class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	# :registerable, :recoverable,
  devise :database_authenticatable,:registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
		:role, :provider, :uid, :nickname, :avatar, :organization_users_attributes, :wants_notifications
	attr_accessor :is_create

  validates :email, :nickname, :presence => true
	before_save :check_for_role

  def self.no_admins
    where("role != ?", ROLES[1])
  end

	# if no role is supplied, default to the basic author role
	def check_for_role
		self.role = User::ROLES[0] if self.role.nil? || self.role.empty?
	end

  # use role inheritence
  ROLES = %w[author admin]
  def role?(base_role)
    if base_role && ROLES.index(base_role.to_s)
      return ROLES.index(base_role.to_s) <= ROLES.index(role)
    end
    return false
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
