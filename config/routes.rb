BootstrapStarter::Application.routes.draw do


	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'},
											 :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

		namespace :admin do
			resources :users
			resources :visualizations
			resources :categories
      resources :pages
			resources :organizations
		  resources :idea_statuses
		end


    # root pages
		match '/about', :to => 'root#about', :as => :about, :via => :get
		match '/data', :to => 'root#data', :as => :data, :via => :get
		match '/data', :to => 'root#data', :as => :data, :via => :post
		match '/submit_visual', :to => 'root#submit_visual', :as => :submit_visual, :via => :get
		match '/submit_visual', :to => 'root#submit_visual', :as => :submit_visual, :via => :post
		match '/terms', :to => 'root#terms', :as => :terms, :via => :get
		match '/rss', :to => 'root#rss', :as => :rss, :via => :get
		match '/contact' => 'root#contact', :as => 'contact', :via => :get
		match '/contact' => 'root#contact', :as => 'contact', :via => :post

		# organization
		resources :organizations, :as => :organization, :path => :organization, :only => [:show, :edit, :update] do
			resources :visualizations, :except => [:index]
		end

		match '/snapshot', :to => 'root#snapshot', :as => :snapshot, :via => :get, :defaults => {:format => 'png'}

    # visualizations
		match '/visualizations', :to => 'visuals#index', :as => :visuals, :via => :get
		match '/visualizations/:id', :to => 'visuals#show', :as => :visualization, :via => :get
		match '/visualizations/search', :to => 'visuals#search', :as => :search, :via => :get
		match '/visualizations/search', :to => 'visuals#search', :as => :search, :via => :post
		match '/visualizations/:id/vote/:status', :to => 'visuals#vote', :as => :visual_vote, :via => :get
		match '/visualizations/comment_notification/:id', :to => 'visuals#comment_notification', :as => :visual_comment_notification, :via => :get
	  match '/visualizations/:id/next', :to => 'visuals#next', :as => :visual_next, :via => :get
	  match '/visualizations/:id/previous', :to => 'visuals#previous', :as => :visual_previous, :via => :get


		# notifications
		match '/notifications', :to => 'notifications#index', :as => :notifications, :via => :get
		match '/notifications', :to => 'notifications#index', :as => :notifications, :via => :post

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
