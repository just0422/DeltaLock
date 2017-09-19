Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  get '' => 'home_page#index'
  get '/get_items' => 'search#render_items', as: 'get_items'
  get '/fetch_purchasers' => 'search#get_purchasers', as: 'fetch_purchasers'
  get '/fetch_endusers' => 'search#get_endusers', as: 'fetch_endusers'
  get '/fetch_keys' => 'search#get_keys', as: 'fetch_keys'
  get '/all_endusers' => 'end_user#all', as: 'all_endusers'
  get '/get_keys_map', to: 'map#map'
  get '/info' => 'search#info', as: 'info'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  get '/users' => 'users#user_management'
  get '/purchaser/show_purchaser/:id', to: 'purchaser#show_purchaser'
  get '/enduser/show_enduser/:id', to: 'end_user#show_enduser'
  get '/key/show_key/:id', to: 'key#show_key'
  get '/search/export/:search_type' => 'search#export', as: 'export'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'

  resources :all
  resources :key
  resources :end_user 
  resources :search do
	  collection { post :result, to: 'search#index' }
  end
  resources :purchaser
  resources :purchase_order
  resources :map
  resources :assign
  resources :upload
  resources :users
  resources :sessions

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
