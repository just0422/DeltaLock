#!/bin/bash

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
rm -f .rbenv-vars

echo "SECRET_KEY_BASE=$secret_key" >> .rbenv-vars
echo "DELTALOCK_DATABASE_USERNAME=$DELTAUSER" >> .rbenv-vars
echo "DELTALOCK_DATABASE_PASSWORD=$DELTAPASS" >> .rbenv-vars

echo -e "\n${BLUE}Removing devise methods from routes and user${NC}"
sleep 1
sed -i '5,10 s/^/#/' config/routes.rb
sed -i '3,4 s/^/#/' app/models/user.rb
sed -i '7 s/^/#/' app/controllers/manage_controller.rb
sed -i '7 s/^/#/' app/controllers/registrations_controller.rb
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

echo -e "\n${BLUE}Installing Unicorn configuration file${NC}"
sleep 0.25
cp install/special_files/unicorn.rb config/unicorn.rb
echo -e "${GREEN}Unicorn file configuration installed${NC}"

mkdir -p shared/pids shared/sockets shared/log

exit 0
