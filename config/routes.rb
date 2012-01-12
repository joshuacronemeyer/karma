Karma::Application.routes.draw do
  
  devise_for :users, :controllers => { :registrations => :registrations }
  
  
  devise_scope :user do  
    match '/sign_in' => 'devise/sessions#new', :via => :get
    match '/sign_out' => 'devise/sessions#destroy', :via => :get
  end
  
  resources :users do
    match :toggle_admin, :via => :post, :action => :toggle_admin, :as => :toggle_admin
  end
  
  # need to add action limiters for resources
  
  resources :notices do
    match :claim, :via => :get, :action => :claim, :as => :claim
 #   match :claim, :via => :put, :action => :update_claimed_status, :as => :update_claimed_status
    collection do
      match :open, :via => :get, :action => :open_index
    end
  end
  
  resources :comments
  
  resources :karma_grants
  

# match '/users/:id/toggle_admin/' => 'users#toggle_admin', :via => :post
  match '/sign_up' => 'users#new', :via => :get
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  root :to => 'pages#home'
  
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
  # match ':controller(/:action(/:id(.:format)))'
end
