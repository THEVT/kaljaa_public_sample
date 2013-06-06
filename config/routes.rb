KaljaaFb::Application.routes.draw do
	resources :accounts do
		member do
			get :following, :followers
		end
	end
	resources :sessions, only: [:new, :create, :destroy]
	resources :microposts, only: [:create, :destroy]
	resources :relationships, only: [:create, :destroy]
	resources :profiles do
		resources :albums
		member do
			get :info
		end
	end
	resources :activities
	resources :albums do
		resources :photos
	end
	resources :articles do
		resources :albums
	end
	resources :beers do
		resources :comments
	end
	resources :beercentrals
	resources :blogs do
		resources :albums
	end
	resources :conversations
	resources :interests
	resources :invites do
		member do
			get 'admin'
			post 'admin'
		end
	end
	resources :events do
		resources :albums
		resources :blogs
		resources :articles
		member do
			get 'invite'
		end
	end
	resources :favbreweries
	resources :favbeers
	resources :friendships do
		member do
			post 'accept'
			get 'accept'
			post 'decline'
			get 'decline'
			post 'cancel'
			get 'cancel'
			post 'delete'
			get 'delete'
		end
	end
	resources :groups do
		resources :albums
		resources :blogs
		resources :articles
		member do
			get 'members'
		end
	end
	resources :honorablebeers
	resources :members do
		member do
			get 'admin'
			post 'admin'
		end
	end
	resources :messages
	resources :miscs
	resources :photos
	resources :abouts
	resources :locations
	resources :reviewbeers do
		resources :comments
	end
	resources :services

	get "users/new"

	root to: 'home#index'

	match '/m_home', to: 'accounts#m_home'	
	match '/signup', to: 'accounts#new'
	match '/copyright', to: 'home#copyright'
	match '/faq', to: 'home#faq'
	match '/learn', to: 'home#learn'
	match '/privacy', to: 'home#privacy'
	match '/support', to: 'home#support'
	match '/terms', to: 'home#terms'
	match '/register', to: 'home#register'
	match '/signin', to: 'sessions#new'
	match '/signout', to: 'sessions#destroy', via: :delete

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
