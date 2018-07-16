#!/bin/bash

# Display colors
RED='\033[0;31m'    # Error
YELLOW='\033[0;33m' # Warning / Prompt
GREEN='\033[0;32m'  # Success
BLUE='\033[0;36m'   # Information
NC='\033[0m'        # Normal white

# Function to confirm and installation
function install(){
	if $1; then
		echo -e "${GREEN}$2 successfully installed!${NC}"
	else
		echo -e "${RED}$2 not installed${NC}"
		exit 1
	fi
}

# Updated all current packages
echo -e "${BLUE}Running apt-get update${NC}"
sudo apt-get -qq update 
echo -e "${GREEN}Packages updated sucessfully${NC}"

# Install necessary packages One-by-one and verify their installation success
pkgs=(git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs autoconf bison libreadline6-dev zlib1g-dev libncurses5-dev libgdbm3 libgdbm-dev nginx )
for pkg in "${pkgs[@]}"
do
	echo -e "${BLUE}Installing $pkg${NC}"
	if sudo dpkg -s "$pkg" >/dev/null; then
		echo -e "${YELLOW}$pkg already installed${NC}"
	elif sudo apt-get -qq -y install "$pkg"; then
		echo -e "${GREEN}$pkg sucessfully installed${NC}"
	else
		echo -e "\t${RED}$pkg not installed${NC}"
	fi

	sleep 0.25
done

# Check to see if MySQL is installed
echo -e "${BLUE}Checking to see if MySQL is installed${NC}"
if sudo mysql --version; then
	echo -e "${GREEN}MySQL is already installed!"
else
	echo -e "${RED}MySQL is not installed${NC}"
	echo -e "${BLUE}Installing MySQL${NC}"
	sleep 1

	sudo apt-get install -qq mysql-server mysql-client libmysqlclient-dev
	sudo mysql_install_db
	sudo mysql_secure_installation
	echo -e "${GREEN}MySQL successfully installed!"
fi

# Ensure that git is configured so that warnings are not given
echo -e "${BLUE}Configuring git...${NC}"
sleep 0.25
git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"
git config --global push.default matching
echo -e "${GREEN}Git configuration successful!${NC}"

# Installing rbenv (used to manage ruby)
cd ~
echo -e "${BLUE}Removing previous .rbenv directory (if it exists)${NC}"
rm -rf .rbenv
echo -e "${BLUE}Cloning rbenv repository${NC}"
sleep 0.25
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo -e "${BLUE}Installing rbenv${NC}"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# Check rbenv installation
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# Retrieve ruby from github and installed it
echo -e "${BLUE}Cloning ruby build into rbenv${NC}"
sleep 0.25
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
echo -e "${BLUE}Installing ruby (this wll take a while...)${NC}"
sleep 1
rbenv install --verbose 2.3.1
rbenv global 2.3.1
install 'ruby -v' 'ruby'

# Install the Rails Package Manager
echo -e "${BLUE}Installing bundle${NC}"
sleep 0.25
install 'gem install --verbose bundler' 'bundle'

# Install Ruby On Rails server
echo -e "${BLUE}Installing Rails (this will take a while too..)${NC}"
sleep 1
gem install --verbose rails -v 4.2.6
rbenv rehash
install 'rails -v' 'Rails'

# Start the MySQL server
echo -e "${BLUE}Starting MySQL${NC}"
sudo service mysql start
sleep 1
if sudo systemctl is-active --quiet mysql; then
    echo -e "${GREEN}MySQL successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting MySQL. Abort...${NC}"
    exit 1
fi

# Create another user (that's NOT root) for MySQL
sleep 1
echo -e "\n${BLUE}Ruby on rails suggests creating another user specifically for the application. For security, this user is different than root.${NC}"
printf "${YELLOW}Please enter DeltaLock MySQL username:${NC} "
read deltauser
while [ "$deltauser" = "root" ]; do
    echo -e "\n\n${RED}Cannot use 'root' username"
    printf "${YELLOW}Please enter DeltaLock MySQL username:${NC} "
    read deltauser
done

printf "${YELLOW}Please enter DeltaLock MySQL password:${NC} "
read -s deltapass
printf "\n${YELLOW}Please confirm DeltaLock MySQL password:${NC} "
read -s deltapassConfirm

while [ "$deltapass" != "$deltapassConfirm" ]; do
    echo -e "\n\n${RED}Passwords do not match. Please try again..."
    printf "${YELLOW}Please enter DeltaLock MySQL password:${NC} "
    read -s deltapass
    printf "\n${YELLOW}Please confirm DeltaLock MySQL password:${NC} "
    read -s deltapassConfirm
done

# Save the root user login info so that it doesn't have to be input each time
sudo mysql_config_editor remove --login-path=root
echo -e "\n\n${YELLOW}Please enter root user MySQL password. This is the same one entered when the screen turned pink. ${NC}"
sudo mysql_config_editor set --login-path=root --host=localhost --user=root --password

echo -e "${BLUE}Creteing rails MySQL user${NC}"
sudo mysql --login-path=root -e "GRANT ALL PRIVILEGES ON *.* TO '${deltauser}'@'localhost' IDENTIFIED BY '${deltapass}';"

# Check the the user was successfully created
USER_EXISTS="$(sudo mysql --login-path=root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user ='${deltauser}')")"
if [ "$USER_EXISTS" = 1 ]; then
    echo -e "${BLUE}${deltauser} ${GREEN}successfully created!${NC}"
else
    echo -e "${RED}There was an issue creating user. Abort...${NC}"
    exit 1
fi

echo "export DELTAUSER=${deltauser}" >> ~/.bashrc
echo "export DELTAPASS=${deltapass}" >> ~/.bashrc

export DELTAUSER="${deltauser}"
export DELTAPASS="${deltapass}"

# Install Rails specific Ruby librarys
cd ~/DeltaLock
echo -e "${BLUE}Installing gems${NC}"
sleep 0.24
install 'bundle install' 'Gems'

# Install Rails environment variables library
echo -e "${BLUE}Cloning rbenv-vars for secret key generation and password protection${NC}"
sleep 0.25
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

# Generate a secret key for the DB
echo -e "${BLUE}Generating secret key${NC}"
sleep 0.25
cd ~/DeltaLock
secret_key="$(rake secret)"
sudo rm -f .rbenv-vars

# Save the key and Username/password
echo "SECRET_KEY_BASE=$secret_key" >> .rbenv-vars
echo "DELTALOCK_DATABASE_USERNAME=$DELTAUSER" >> .rbenv-vars
echo "DELTALOCK_DATABASE_PASSWORD=$DELTAPASS" >> .rbenv-vars

# Comment out devise references in the app
echo -e "\n${BLUE}Removing devise methods from routes and user${NC}"
sleep 1
sed -i '5,10 s/^/#/' config/routes.rb
sed -i '3,4 s/^/#/' app/models/user.rb
sed -i '7 s/^/#/' app/controllers/manage_controller.rb
sed -i '7 s/^/#/' app/controllers/registrations_controller.rb
rm config/initializers/devise.rb
sleep 0.5

# INstall devise
echo -e "${BLUE}Installing devise library (for user management}${NC}"
sleep 1
RAILS_ENV=production rails generate devise:install
echo -e "${GREEN}Installed devise library successfully${NC}"

# Uncomment defives references in the app
sleep 0.25
echo -e "${BLUE}Adding devise methods back to routes and user${NC}"
sleep 1
sed -i '5,10 s/#//' config/routes.rb
sed -i '3,4 s/#//' app/models/user.rb
sed -i '7 s/#//' app/controllers/manage_controller.rb
sed -i '7 s/#//' app/controllers/registrations_controller.rb
sleep 0.5

# Create the Deltalock database
echo -e "\n${BLUE}Creating DeltaLock database and tables${NC}"
sleep 1
RAILS_ENV=production rake db:create db:schema:load
echo -e "${GREEN}Created DeltaLock database and tables successfully${NC}"

# Compile all the static resources (located in app/assets
echo -e "\n${BLUE}Compiling stylesheets and javascripts${NC}"
sleep 1
RAILS_ENV=production rake assets:precompile
echo -e "${GREEN}Compiled stylesheets and javascripts successfully${NC}"

# Create a default app user
echo -e "\n${BLUE}Please enter information for default DeltaLock administrator user. If left blank, default will be used (in parentheses). This does not pertain to the database. The information entered here will be the same that is used to login to the application for the first time${NC}"
printf "${YELLOW}First name (Admin): ${NC}"
read adminfirst
printf "${YELLOW}Last name (User): ${NC}"
read adminlast
printf "${YELLOW}Email (admin@deltalock.biz): ${NC}"
read adminuser
echo -e "${YELLOW}Password must contain at least 6 characters${NC}"
printf "${YELLOW}Password (abc123): ${NC}"
read -s adminpass
printf "\n${YELLOW}Password confirmation: ${NC}"
read -s adminpassConfirm

echo ""

# Validate passwords
while [[ "$adminpass" != "$adminpassConfirm" ||  ${#adminpass} -lt 6 ]]; do
    if [ ${#adminpass} -eq 0 ]; then
        break
    fi
    if [ ${#adminpass} -lt 6 ]; then
        echo -e "${RED}Password must contain at least 6 characters${NC}"
    fi
    if [ "$adminpass" != "$adminpassConfirm" ]; then
        echo -e "${RED}Passwords do not match. Please try again..."
    fi
    printf "${YELLOW}Password (abc123): ${NC}"
    read -s adminpass
    printf "\n${YELLOW}Password confirmation: ${NC}"
    read -s adminpassConfirm

    echo ""
done

adminfirst=${adminfirst:-Admin}
adminlast=${adminlast:-User}
adminuser=${adminuser:-admin@deltalock.biz}
adminpass=${adminpass:-abc123}

# Create the user
echo -e "\n${BLUE}Creating User - ${adminfirst} ${adminlast}${NC}"
RAILS_ENV=production rails runner 'User.destroy_all'
RAILS_ENV=production rails runner 'User.create!(first_name: "'"$adminfirst"'", last_name:"'"$adminlast"'", email:"'"$adminuser"'", password:"'"$adminpass"'").add_role("admin")'
echo -e "${YELLOW}Validating User - ${adminfirst} ${adminlast}${NC}"
RAILS_ENV=production rails runner 'User.first'
if [ $? == 0 ]; then
    echo -e "${GREEN}User (${adminfirst} ${adminlast}) successfully created${NC}"
else
    echo -e "${RED}User not created. Abort...${NC}"
    exit 1
fi

# Copy the rails unicorn config file into the config directory
echo -e "\n${BLUE}Installing Unicorn configuration file${NC}"
sleep 0.1
cp install/special_files/unicorn.rb config/unicorn.rb
echo -e "${GREEN}Unicorn file configuration installed${NC}"

# Make unicorn directories in rails project
mkdir -p shared/pids shared/sockets shared/log

# Copy unicorn startup script to /etc/init.d
echo -e "${BLUE}Copying unicorn startup script to /etc/init.d${NC}"
sleep 1
sudo cp install/special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
sudo sed -i 's/DELTALOCK_USERNAME_PLACEHOLDER/'"$USER"'/g' /etc/init.d/unicorn_deltalock
sudo sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/init.d/unicorn_deltalock
echo -e "${GREEN}Copied unicorn startup script successfully${NC}"
echo -e "\n${BLUE}Adjusting unicorn startup script permissions${NC}"
sleep 1
sudo chmod 755 /etc/init.d/unicorn_deltalock
sudo update-rc.d unicorn_deltalock defaults
echo -e "\n${GREEN}Adjusting permissions successfully${NC}"

# Start the unicorn app server
echo -e "${BLUE}Starting  unicorn${NC}"
sudo service unicorn_deltalock start

if sudo systemctl is-active --quiet unicorn_deltalock; then
    echo -e "${GREEN}Unicorn Application Servier successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Unicorn. Abort...${NC}"
    exit 1
fi

# Copy nginx setup files to /etc/nginx
echo -e "${BLUE}Copying configuration file to Nginx${NC}"
sudo cp install/special_files/nginx_config /etc/nginx/sites-available/default
sudo sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/nginx/sites-available/default
echo -e "${GREEN}Copied configuration file sucessfully${NC}"

# Start the nginx server
echo -e "${BLUE}Starting Nginx server${NC}"
sudo service nginx restart

# Validate nginx installation
if sudo systemctl is-active --quiet nginx; then
    echo -e "${GREEN}Nginx Server successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Nginx. Abort...${NC}"
    exit 1
fi

# DONE
echo -e "${YELLOW}--------------------------------------------------------"
echo -e "${YELLOW}|${BLUE}       DeltaLock Software ${GREEN}Successfully ${BLUE}Installed!      ${YELLOW}|"
echo -e "${YELLOW}--------------------------------------------------------${NC}"
