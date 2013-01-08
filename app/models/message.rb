class Message
	include ActiveAttr::Model

	attribute :name
	attribute :email
	attribute :subject
	attribute :message
	attribute :org_message
	attribute :url
	attribute :url_id
	attribute :bcc
	attribute :locale

	attr_accessible :name, :email, :message, :subject, :org_message, :url, :bcc, :url_id

  validates_presence_of :email, :message, :subject
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :message, :maximum => 500

	def locale
		I18n.locale
	end

end
