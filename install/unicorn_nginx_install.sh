#!/bin/bash

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
install 'bundle install' 'Gems'


echo -e "${YELLOW}CONNECT TO DB NOW${NC}"
echo -e "${BLUE}config/database.yml${NC}"



echo -e "${BLUE}Cloning rbenv-vars for secret key generation and password protection"
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

echo -e "${BLUE}Generating secret key"
cd ~/DeltaLock
secret_key="$(rake secret)"

echo "SECRET_KEY_BASE=$secret_key" >> .rbenv-vars
echo "DELTALOCK_DATABASE_PASSWORD=prod_db_pass" >> .rbenv-vars


RAILS_ENV=production rake db:create
RAILS_ENV=production rake assets:precompile
#RAILS_ENV=production rails server --binding= #PUBLIC IP

exit 0

echo "gem 'unicorn'" >> Gemfile
bundle
echo special_files/unicorn.rb >> confige/unicorn.rb

mkdir -p shared/pids shared/sockets shared/log

cp special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
chmod 755 /etc/init.d/unicorn_deltalock
update-rc.d unicorn_deltalock defaults

