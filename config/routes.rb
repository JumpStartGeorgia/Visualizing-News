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
			resources :categories
      resources :pages
			resources :organizations
		  resources :idea_statuses
		end


    # root pages
		match '/about', :to => 'root#about', :as => :about, :via => :get
		match '/data', :to => 'root#data', :as => :data, :via => [:get, :post]
		match '/submit_visual', :to => 'root#submit_visual', :as => :submit_visual, :via => [:get, :post]
		match '/terms', :to => 'root#terms', :as => :terms, :via => :get
		match '/rss', :to => 'root#rss', :as => :rss, :via => :get
		match '/contact' => 'root#contact', :as => 'contact', :via => [:get, :post]

		# organization
#		resources :organizations, :as => :organization, :path => :organization, :only => [:show, :edit, :update] do
#			resources :visualizations, :except => [:index]
#		end

    # visualizations
    resources :visualizations do
      collection do
        get :ajax, :defaults => {:format => 'js'}
        get 'comment_notification/:id', :action => 'comment_notification', :as => 'comment_notification'
      end
      member do 
        get :next
        get :previous
        get :promote
        get :unpromote
        get 'vote/:status', :action => 'vote', :as => 'vote'
      end
    end
    
=begin
		match '/visualizations/ajax', :to => 'visuals#ajax', :as => :visuals_ajax, :via => :get, :defaults => {:format => 'js'}
		match '/visualizations', :to => 'visuals#index', :as => :visuals, :via => :get
		match '/visualizations/:id', :to => 'visuals#show', :as => :visualization, :via => :get
		match '/visualizations/:id/vote/:status', :to => 'visuals#vote', :as => :visual_vote, :via => :get
		match '/visualizations/comment_notification/:id', :to => 'visuals#comment_notification', :as => :visual_comment_notification, :via => :get
	  match '/visualizations/:id/next', :to => 'visuals#next', :as => :visual_next, :via => :get
	  match '/visualizations/:id/previous', :to => 'visuals#previous', :as => :visual_previous, :via => :get
	  match '/visualizations/:id/promote', :to => 'visuals#promote', :as => :visual_promote, :via => :get
	  match '/visualizations/:id/unpromote', :to => 'visuals#unpromote', :as => :visual_unpromote, :via => :get
=end

    # ideas
		match '/ideas/ajax', :to => 'ideas#ajax', :as => :ideas_ajax, :via => :get, :defaults => {:format => 'js'}
		match '/ideas', :to => 'ideas#index', :as => :ideas, :via => :get
		match '/ideas/:id', :to => 'ideas#show', :as => :idea, :via => :get
		match '/ideas/user/:id', :to => 'ideas#user', :as => :user_ideas, :via => :get
		match '/ideas/organization/:id', :to => 'ideas#organization', :as => :organization_ideas, :via => :get
		match '/ideas/create', :to => 'ideas#create', :as => :create_idea, :via => :post
		match '/ideas/:id/vote/:status', :to => 'ideas#vote', :as => :idea_vote, :via => :get
		match '/ideas/comment_notification/:id', :to => 'ideas#comment_notification', :as => :idea_comment_notification, :via => :get
		match '/ideas/follow_idea/:idea_id', :to => 'ideas#follow_idea', :as => :follow_idea, :via => :get
		match '/ideas/unfollow_idea/:idea_id', :to => 'ideas#unfollow_idea', :as => :unfollow_idea, :via => :get
	  match '/ideas/:id/next', :to => 'ideas#next', :as => :idea_next, :via => :get
	  match '/ideas/:id/previous', :to => 'ideas#previous', :as => :idea_previous, :via => :get
	  match '/ideas/:id/delete', :to => 'ideas#delete', :as => :idea_delete, :via => :get
	  match '/ideas/:id/edit', :to => 'ideas#edit', :as => :idea_edit, :via => :get
	  match '/ideas/:id/edit', :to => 'ideas#edit', :as => :idea_edit, :via => :post
  

    namespace :ideas do
  		# idea progress
		  match '/progress/claim/:idea_id/:organization_id', :to => 'progress#claim', :as => :claim, :via => :get
		  match '/progress/new/:idea_id/:organization_id', :to => 'progress#new', :as => :progress_update, :via => :get
		  match '/progress/edit/:id', :to => 'progress#edit', :as => :edit_progress, :via => :get
		  match '/progress/create', :to => 'progress#create', :as => :create_progress, :via => :post
		  match '/progress/update/:id', :to => 'progress#update', :as => :update_progress, :via => :put

		  # report idea
		  match '/report/inappropriate/:idea_id', :to => 'report#inappropriate', :as => :report_inappropriate, :via => :get
		  match '/report/inappropriate/:idea_id', :to => 'report#inappropriate', :as => :report_inappropriate, :via => :post
    end

		# notifications
		match '/notifications', :to => 'notifications#index', :as => :notifications, :via => :get
		match '/notifications', :to => 'notifications#index', :as => :notifications, :via => :post

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

  match '/unset_cookie', :to => 'root#unset_cookie', :as => :unset_cookie, :via => :get

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
