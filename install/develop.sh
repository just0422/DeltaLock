#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

function install(){
	if $1; then
		echo -e "${GREEN}$2 successfully installed!${NC}"
	else
		echo -e "${RED}$2 not installed${NC}"
		exit 1
	fi
}

echo -e "${BLUE}Running apt-get update${NC}"
sudo apt-get -qq update 
echo -e "${GREEN}Packages updated sucessfully${NC}"

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

echo -e "${BLUE}Configuring git...${NC}"
sleep 0.25
git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"
git config --global push.default matching
echo -e "${GREEN}Git configuration successful!${NC}"

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

echo -e "${BLUE}Cloning ruby build into rbenv${NC}"
sleep 0.25
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

echo -e "${BLUE}Installing ruby (this wll take a while...)${NC}"
if ruby -v; then
	echo -e "${GREEN}Ruby already installed${NC}"
else
	sleep 1
	#source ~/.bashrc
	rbenv install --verbose 2.3.1
	rbenv global 2.3.1
	install 'ruby -v' 'ruby'
fi

echo -e "${BLUE}Installing bundle${NC}"
sleep 0.25
install 'gem install --verbose bundler' 'bundle'

echo -e "${BLUE}Installing Rails (this will take a while too..)${NC}"
if rails -v; then
	echo -e "${GREEN}Rails already installed${NC}"
else
	sleep 1
	gem install --verbose rails -v 4.2.6
	rbenv rehash
	install 'rails -v' 'Rails'
fi

echo -e "${BLUE}Starting MySQL${NC}"
sudo service mysql start
sleep 1
if sudo systemctl is-active --quiet mysql; then
    echo -e "${GREEN}MySQL successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting MySQL. Abort...${NC}"
    exit 1
fi

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

sudo mysql_config_editor remove --login-path=root
echo -e "\n\n${YELLOW}Please enter root user MySQL password. This is the same one entered when the screen turned pink. ${NC}"
sudo mysql_config_editor set --login-path=root --host=localhost --user=root --password

echo -e "${BLUE}Createing rails MySQL user${NC}"
sudo mysql --login-path=root -e "GRANT ALL PRIVILEGES ON *.* TO '${deltauser}'@'localhost' IDENTIFIED BY '${deltapass}';"

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


cd ~/DeltaLock
echo -e "${BLUE}Installing gems${NC}"
sleep 0.24
install 'bundle install' 'Gems'


echo -e "${BLUE}Cloning rbenv-vars for secret key generation and password protection${NC}"
sleep 0.25
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

echo -e "${BLUE}Generating secret key${NC}"
sleep 0.25
cd ~/DeltaLock
secret_key="$(rake secret)"
sudo rm -f .rbenv-vars

echo "SECRET_KEY_BASE=$secret_key" >> .rbenv-vars
echo "DELTALOCK_DATABASE_USERNAME=$DELTAUSER" >> .rbenv-vars
echo "DELTALOCK_DATABASE_PASSWORD=$DELTAPASS" >> .rbenv-vars

echo -e "\n${BLUE}Removing devise methods from routes and user${NC}"
sleep 1
sed -i '5,10 s/^/#/' config/routes.rb
sed -i '3,4 s/^/#/' app/models/user.rb
sed -i '7 s/^/#/' app/controllers/manage_controller.rb
sed -i '7 s/^/#/' app/controllers/registrations_controller.rb
rm config/initializers/devise.rb
sleep 0.5

echo -e "${BLUE}Installing devise library (for user management}${NC}"
sleep 1
RAILS_ENV=production rails generate devise:install
echo -e "${GREEN}Installed devise library successfully${NC}"

sleep 0.25
echo -e "${BLUE}Adding devise methods back to routes and user${NC}"
sleep 1
sed -i '5,10 s/#//' config/routes.rb
sed -i '3,4 s/#//' app/models/user.rb
sed -i '7 s/#//' app/controllers/manage_controller.rb
sed -i '7 s/#//' app/controllers/registrations_controller.rb
sleep 0.5

echo -e "\n${BLUE}Creating DeltaLock database and tables${NC}"
sleep 1
RAILS_ENV=production rake db:create db:schema:load
echo -e "${GREEN}Created DeltaLock database and tables successfully${NC}"

echo -e "\n${BLUE}Compiling stylesheets and javascripts${NC}"
sleep 1
RAILS_ENV=production rake assets:precompile
echo -e "${GREEN}Compiled stylesheets and javascripts successfully${NC}"

echo -e "\n${BLUE}Please enter information for default administrator user. If left blank, default will be used (in parentheses). ${NC}"
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


