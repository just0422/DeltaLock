Rails.application.routes.draw do
# REORGANIZE ME TO LOOK NICER. TUCK EVERYTHING INTO RESOURCES
  get '' => 'home_page#index'
  get '/get_keys_map', to: 'map#map'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  get '/users' => 'users#user_management'
  get '/show/:type/:id', to: 'entry#show', as: 'show_entry'
  get '/edit/:type/:id', to: 'entry#edit', as: 'edit_entry'
  get '/new', to: 'entry#new', as: 'new_entry'
  get '/assign/new/:type', to: 'assign#new', as: 'new_assign'
  get '/assign/search/:type', to: 'assign#search', as: 'search_assign'
  get '/assign/manage', to: 'assign#manage'
  get '/assign/edit/:id', to: 'assign#edit', as: 'edit_assign'
  get '/manage', to: 'manage#index'
  
  post '/search/export/:search_type' => 'search#export', as: 'export'
  post '/update/:type/:id', to: 'entry#update', as: 'update_entry'
  post '/assign/create/:type', to: 'assign#create', as: 'create_assign'
  post '/assign/result/:type', to: 'assign#result', as: 'result_assign'
  post '/assign/update/:id', to: 'assign#update', as: 'update_assign'
  post '/assign/group', to: 'assign#session_group', as: 'session_group'
  post '/assign/assignment', to: 'assign#assignment'
  post '/manage/upload', to: 'manage#upload', as: 'upload_manage'
  post '/manage/download/:template/:type', to: 'manage#download', as: 'download'
  post '/create/:type', to: 'entry#create', as: 'create_entry'


  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'
  delete '/delete/:type/:id', to: 'entry#delete', as: 'delete_entry'
  delete '/delete/:id', to: 'assign#delete', as: 'delete_assign'

  resources :all
  resources :search do
	  collection { post :result, to: 'search#items' }
  end
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
