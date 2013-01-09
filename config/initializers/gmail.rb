if Rails.env.production? || Rails.env.staging?
	ActionMailer::Base.smtp_settings = {
		:address              => "smtp.gmail.com",
		:port                 => 587,
		:domain               => 'www.feradi.info',
		:user_name            => ENV['FERADI_FEEDBACK_TO_EMAIL'],
		:password             => ENV['FERADI_FEEDBACK_FROM_PWD'],
		:authentication       => 'plain',
		:enable_starttls_auto => true
	}
end
