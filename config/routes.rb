Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

    root to: "home_page#index"

    get '' => 'home_page#index'
    get '/show/:type/:id', to: 'entry#show', as: 'show_entry'
    get '/edit/:type/:id', to: 'entry#edit', as: 'edit_entry'
    get '/new', to: 'entry#new', as: 'new_entry'
    get '/assign/new/:type', to: 'assign#new', as: 'new_assign'
    get '/assign/search/:type', to: 'assign#search', as: 'search_assign'
    get '/assign/manage', to: 'assign#manage'
    get '/assign/edit/:id', to: 'assign#edit', as: 'edit_assign'
    get '/assign/filter/map', to: 'assign#filter_map', as: 'filter_map'
    get '/manage', to: 'manage#index'

    post '/search/export/:search_type' => 'search#export', as: 'export'
    post '/update/:type/:id', to: 'entry#update', as: 'update_entry'
    post '/assign/create/:type', to: 'assign#create', as: 'create_assign'
    post '/assign/result/:type', to: 'assign#result', as: 'result_assign'
    post '/assign/update/:id', to: 'assign#update', as: 'update_assign'
    post '/assign/enduser', to: 'assign#session_enduser', as: 'session_enduser'
    post '/assign/update_map', to: 'assign#update_map', as: 'update_map'
    post '/assign/assignment', to: 'assign#assignment'
    post '/manage/upload', to: 'manage#upload', as: 'upload_manage'
    post '/manage/download/:template/:type', to: 'manage#download', as: 'download'
    post '/create/:type', to: 'entry#create', as: 'create_entry'


    delete '/delete/:type/:id', to: 'entry#delete', as: 'delete_entry'
    delete '/delete/:id', to: 'assign#delete', as: 'delete_assign'

    resources :search do
        collection { post :result, to: 'search#items' }
    end
    resources :assign
    resources :upload
    resources :sessions
end
