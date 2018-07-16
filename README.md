# DeltaLock Inc.

Welcome to DeltaLock's key management software. This software is designed and implemented for the sole use of DeltaLock Inc. This application is built on RubyOnRails 5.

## Table of Contents
* [Requirements](#requirements)
* [Installation](#installation)
* [Important Files](#important-files)
* [Applying Fixes](#applying-fixes)

## Requirements
* Root access to a server running Ubuntu 16.04

## Installation
Installation should be a very simply setup. There are two installation scripts in the install directory that will install all necessary files. 

### Installation details
This will install every aspect of the application. There are, however, individual aspects that can be installed for development purposes. These are the important files for installation:
```
Makefile
install/
|--- development.sh
|--- production.sh
|--- special_files/
|    |--- nginx_config
|    |--- unicorn_init.sh
|    |--- unicorn.rb
```
The installation script begins by installing all necessary libraries for rails to function. During the installation, the MySQL database software is installed. There will be a default user named `root` that is created. The installer will ask for a password for `root`. For development, this password need not be secure. For production however, this should be a very secure password. After the software is installed, it's security is checked. The `root` password must be entered once. There will be a list of questions to answer based off of how secure you need the database to be.
Following the database install, `ruby` and `rails` get installed. Both of these take a long time. If seems like either one is stuck, give it a few more minutes before attempting to restart. After `ruby` and `rails` are installed, MySQL is started. It is recommended by `rails` that the database user for the applicationis *not* `root`. Therefore, the installation will prompt for a `DeltaLock MySQL username`:
```
$ Please enter DeltaLock MySQL username: SAMPLE_USERNAME
$ Please enter DeltaLock MySQL password:
$ Please confirm DeltaLock MySQL password:
```
This will be unique to the application. It will also prompt for a password. After the database user is created, the application can be installed. The DeltaLock database tables can be created and assets compiled. The next thing that the install script will ask for is the default admin user. Since the DeltaLock app needs to be logged into to be used, the app can't be created without any users. The script provides a default first name, last name, email, and password, but they may be changed if desired.
```
$ First name (Admin): SAMPLE_FIRST_NAME
$ Last name (User):
$ Email (admin@deltalock.biz):
$ Password (abc123):
$ Password confirmation:
...
$ Creating User - SAMPLE_FIRST_NAME User
```
At this point, the development installation is over. You can open another terminal, navigate to the DeltaLock directory and type `rails server`. The rails server will start and you can visit the local website at this URL address: [http://localhost:3000](http://localhost:3000).
For production, rails will install unicorn and nginx.

### Development
The `Makefile` is the simplest way to install any of these pieces. To setup for development run:
```
$ make development
```
If installation is successful, this will be displayed:
```
------------------------------------------------------------
| DeltaLock Development Environment Successfuly Installed! |
------------------------------------------------------------
You can start the rails development server by executing the command: 'rails server'. Then navigate to http://localhost:3000 in a web browser
```
### Production
For a complete installation:
```
$ git clone git@github.com:just0422/DeltaLock.git
$ cd DeltaLock
$ make
```
*Note: the program `make` needs to be installed prior to executing any of the install scripts. If it is not, simply issue the command `sudo apt install make`. Then, enter the user password. `make` will install.*

If installation is successful, this will be displayed:
```
----------------------------------------------------------------
|           DeltaLock Software Successfuly Installed!          |
----------------------------------------------------------------
```

## Important Files
At this point, the app has been installed and is running. Take a look the directories and files that rails contains:
```
app/            # *Directory for most of the code that the app uses for Delta
bin/            # Binary files used by rails (never touched)
config/         # *Rails files necessary for run
config.ru       # Points to rails files
db/             # *Database management
Gemfile         # Third party library manager
Gemfile.lock    # Auto-generated third party library dependency manager
install/        # Install directory (not shipped with default rails)
lib/            # *Custom library code
log/            # logging directory
Makefile        # Install file (not shipped with default rails)
public/         # Static files that are used for special cases
Rakefile        # Rails config file
releases/       # Release versions
revisions.log   # Log for revisions
spec/           # *Testing directory
test/           # Rails default testing directory
tmp/            # Temporary directory
vendor/         # Storage for manually inserted asset files (javascripts / stylesheets)
```
All directories denoted with a `*` are most important for the function of the app. They'll be reviewed below
### app/
The `app/` directory is the place where most of the DeltaLock code exists. Here is its directory structure:
```
assets/         # Storage for app specific images, javascripts, stylesheets 
controllers/    # Middleman between database and browser
helpers/        # helper functions (mostly unused)
mailers/        # Email management (unused)
models/         # Database representation
views/          # Part ruby, part HTML pages taht are sent to the browser
```
There's more on how this works later
### config/
Here, the app is configured to work. Most of the files aren't usually touched:
```
application.rb  # application setup
boot.rb         # gem setup
database.yml    # *database setup
environment.rb  # server environment setup
environments    # server environment setup
initializers    # app varaible setup
locales         # 
routes.rb       # *url routing
secrets.yml     # secret values for authentication
unicorn.rb      # unicorn setup
```
#### database.yml
This file looks like this:
```
default: &default
  adapter: mysql2
    encoding: utf8
      pool: 5
        username: root
          password: 12345

          development:
            <<: *default
              database: DeltaLock_development

              test:
                <<: *default
                  database: DeltaLock_test

                  production:
                    <<: *default
                      database: DeltaLock_production
                        username: administrator
                          password: <%= ENV['DELTALOCK_DATABASE_PASSWORD'] %>
                            socket: /var/run/mysqld/mysqld.sock
                            ```
                            It contains all the info for connecting with the database
#### routes.rb
                            The routes file looks liek this:
                            ```
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
                                                                                                                                                                                                        ```
                                                                                                                                                                                                        This file is pivotal  in the function of the app. Every single request that comes from the browser stops at this file before figuring out where to go next. It matches with a path above and then enders the controller at the function indicated by `to:`.

                                                                                                                                                                                                        For instance [localhost:3000/entry/show/endusers/1](http://localhost:3000/entry/show/endusers/1) will match with the `/entry/show/:type/:id` route. It will be passed to the entry conroller (`app/controllers/entry_controller.rb`) to the `show()` function. The app will pass "endusers" and "1" as parameters to the `show()` function. After this, unless otherwise specified, the show view for the entry controller (`app/views/enntry/show.html.erb`) will be rendered.

                                                                                                                                                                                                        *Files with an extension `.erb` will have ruby inserted inside of them. This allows the controller to pass information to the view*


### db/
Here are the files in this directory:
```
migrate         # Handles all changes with the database 
schema.rb       # An outline of the database
seeds.rb        # Sample data
```
Whenever a change is made in the database, a migration must be created. After it's been created, you run:
```
$ rails db:migrate
```
This will apply the change. The `schema.rb` file is always automatically generated after a migration is complete.

In order to populate the database with fake data, fill the `seeds.rb` file with data and run:
```
$ rails db:seed
```
### lib/
Here are the files in this directory:
```
ColumnTitles.rb     # Mapping of database column names to human readable column names
import_functions.rb # Functions to import uploaded data
```
### spec/
The spec directory contains tests for the models in the application and can be run by entering the following comand:
```
$ bundle exec rspec
```
*Note, this testing software will only work when the application is setup for development*

## Applying Fixes
After all development changes have been made, code can be moved to the production server. After the code has been moved, any new gems need to be installed. Each command has to be preceded with `RAILS_ENV=production` to make sure that the change is applied to the production side of rails:
```
$ RAILS_ENV=production bundle install
```
Next, any database changes need to be applied:
```
$ RAILS_ENV=production rails db:migrate
```
Then static assests (located in `app/assest`) have to been compiled and moved to public:
```
$ RAILS_ENV=production rails assets:precompile
```
Lastly the unicorn service must be restarted:
```
$ sudo service unicorn_deltalock restart
```
At this point the app should be ready to go and accessed via the server address.
