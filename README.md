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
Installation should be a very simply setup. There are installation scripts in the install directory that will install all necessary files. 

### Production
For a complete installation:
```
$ git clone git@github.com:just0422/DeltaLock.git
$ cd DeltaLock
$ make
```
*Note: the program `make` needs to be installed prior to executing any of the install scripts. If it is not, simply issue the command `sudo apt install make`. Then, enter the user password. `make` will install.*
This will install every aspect of the application. There are, however, individual aspects that can be installed for development purposes. These are the important files for installation:
```
Makefile
install/
|--- db_unicorn.sh
|--- dependencies.sh
|--- node_mysql.sh
|--- rails_install.sh
|--- special_files/
|    |--- nginx_config
|    |--- unicorn_init.sh
|    |--- unicorn.rb
|--- unicorn_nginx.sh
```
### Development
The `Makefile` is the simplest way to install any of these pieces. For development purposes, the `unicorn_nginx.sh` file does not need to be run. To setup for development run:
```
$ make dependencies
```
This will install all the libraries that rails is dependent on. The next step is to install rails:
```
$ make rails
```
This may take a while, but will completely install `ruby` and `rails`. The next command sets up the database:
```
$ make node_mysql

** At some point, the installer will ask for a database user and password. 
** Simply supply the following information
Username: root
Password: 12345
```
After the database is installed, it is time to set it up. There is one small disclaimer though. Running the setup script may also install a gem called `unicorn`. If it installs, there is no issue. It will not affect anything unless it is configured (which happens in `unicorn_ngnx.sh`). However, if you don't want it installed, make sure that this line is commented out in `db_unicorn.sh`:
```
*** install/db_unicorn.sh ***

51: # echo "gem 'unicorn'" >> Gemfile
```
After this, run the following script to configure the database:
```
$ make db_unicorn
```
After all of this has completed,  you should be able to run the follow command:
```
$ rails server
```
If all is well this will start up a server that begins listening on port 3000. You can't navigate there in a browser just yet. Although the appropriate software has been installed, the application software has yet to be installed. Stop the server by typing `CTRL + C`. Execute the following commands to make sure that the application gets installed successfully:
```
$ bundle install
...
$ rails db:create
$ rails db:migrate
```
At this point, the application should be all set up. Start the server once more with `rails server`, open a browser and navigate to [localhost:3000](http://localhost:3000).

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
