Rails.application.routes.draw do
    devise_for :users, :controllers => { registrations: 'registrations' }
    devise_scope :user do
        delete "users/:id" => "registrations#destroy", :as => :delete_user
        get "users/:id" => "registrations#edit", :as => :edit_user
    end

    root to: "home_page#index"

    get '' => 'home_page#index'

    get '/entry/show/:type/:id', to: 'entry#show', as: 'show_entry'
    get '/entry/edit/:type/:id', to: 'entry#edit', as: 'edit_entry'
    get '/entry/new', to: 'entry#new', as: 'new_entry'
    post '/entry/create/:type', to: 'entry#create', as: 'create_entry'
    post '/entry/update/:type/:id', to: 'entry#update', as: 'update_entry'
    delete '/entry/delete/:type/:id', to: 'entry#delete', as: 'delete_entry'

    get '/search', to: 'search#index'
    post '/search/export/:search_type' => 'search#export', as: 'export'
    post '/search/result' => 'search#items', as: 'search_result'
    
    get '/assign', to: 'assign#index'
    get '/assign/new/:type', to: 'assign#new', as: 'new_assign'
    get '/assign/search/:type', to: 'assign#search', as: 'search_assign'
    get '/assign/manage', to: 'assign#manage'
    get '/assign/edit/:id', to: 'assign#edit', as: 'edit_assign'
    get '/assign/filter/map', to: 'assign#filter_map', as: 'filter_map'
    post '/assign/create/:type', to: 'assign#create', as: 'create_assign'
    post '/assign/result/:type', to: 'assign#result', as: 'result_assign'
    post '/assign/update/:id', to: 'assign#update', as: 'update_assign'
    post '/assign/enduser', to: 'assign#session_enduser', as: 'session_enduser'
    post '/assign/update_map', to: 'assign#update_map', as: 'update_map'
    post '/assign/assignment', to: 'assign#assignment'
    delete '/assign/delete/:id', to: 'assign#delete', as: 'delete_assign'

    get '/manage', to: 'manage#index'
    post '/manage/upload', to: 'manage#upload', as: 'upload_manage'
    post '/manage/download/:template/:type', to: 'manage#download', as: 'download'
end
