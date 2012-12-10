BootstrapStarter::Application.routes.draw do

	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users
		namespace :admin do
			resources :users
			resources :story_types
			resources :stories
			resources :categories
		end


		match '/story/:id', :to => 'root#story', :as => :story, :via => :get
		match '/category/:id', :to => 'root#category', :as => :category, :via => :get
		match '/search', :to => 'root#search', :as => :search, :via => :get
		match '/search', :to => 'root#search', :as => :search, :via => :post
		match '/vote/:type/:votable_id/:status', :to => 'root#vote', :as => :vote, :via => :get
		match '/comment_notification/:idea_id', :to => 'root#comment_notification', :as => :comment_notification, :via => :get


		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
