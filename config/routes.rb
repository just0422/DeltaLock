Rails.application.routes.draw do
    # Routing for user management.
    # This is handled by a separate library. There are a few overridden functions
    #   that are setup to allow user management by an admin
    devise_for :users, :controllers => { registrations: 'registrations' }
    devise_scope :user do
        get "users/edit/:id"    => "registrations#edit_users",      :as => :edit_user
        put "users/update"      => "registrations#update_users",    :as => :update_user
        delete "users/:id"      => "registrations#destroy_users",   :as => :delete_user
    end

    # Starting point of the app. app/controller/home_page_controller.rb - index()
    root to: "home_page#index"
    get '' => 'home_page#index'
    
    # These are all the routes for the individual pages of each element (standard rails CRUD routes)
    get '/entry/show/:type/:id',        to: 'entry#show',   as: 'show_entry'
    get '/entry/new',                   to: 'entry#new',    as: 'new_entry'
    get '/entry/edit/:type/:id',        to: 'entry#edit',   as: 'edit_entry'
    post '/entry/create/:type',         to: 'entry#create', as: 'create_entry'
    post '/entry/update/:type/:id',     to: 'entry#update', as: 'update_entry'
    delete '/entry/delete/:type/:id',   to: 'entry#delete', as: 'delete_entry'

    # These are all the routes for the search pages
    get '/search',         to: 'search#index',  as: 'search'
    post '/search/result', to: 'search#result', as: 'search_result'
    
    # These are all the routes for the assign page
    get '/assign',                  to: 'assign#index'
    get '/assign/new/:type',        to: 'assign#new',               as: 'new_assign'
    get '/assign/search/:type',     to: 'assign#search',            as: 'search_assign'
    get '/assign/edit/:id',         to: 'assign#edit',              as: 'edit_assign'
    get '/assign/filter/map',       to: 'assign#filter_map',        as: 'filter_map'
    post '/assign/create/:type',    to: 'assign#create',            as: 'create_assign'
    post '/assign/result/:type',    to: 'assign#result',            as: 'result_assign'
    post '/assign/update/:id',      to: 'assign#update',            as: 'update_assign'
    post '/assign/enduser',         to: 'assign#session_enduser',   as: 'session_enduser'
    post '/assign/update_map',      to: 'assign#update_map',        as: 'update_map'
    post '/assign/assignment',      to: 'assign#assignment',        as: 'assignment'
    delete '/assign/delete/:id',    to: 'assign#delete',            as: 'delete_assign'

    get '/manage',                          to: 'manage#index'
    get '/manage/download/:template/:type', to: 'manage#download',  as: 'download'
    post '/manage/upload',                  to: 'manage#upload',    as: 'upload_manage'
end
