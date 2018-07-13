#!/bin/bash

. ./install/node_mysql.sh

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

function install(){
	if $1; then
		echo -e "${GREEN}$2 successfully installed!${NC}"
	else
		echo -e "${RED}$2 not installed${NC}"
		exit 1
	fi
}

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
