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
install 'bundle install' 'Gems'


echo -e "${YELLOW}CONNECT TO DB NOW${NC}"
echo -e "${BLUE}config/database.yml${NC}"



echo -e "${BLUE}Cloning rbenv-vars for secret key generation and password protection${NC}"
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

echo -e "${BLUE}Generating secret key${NC}"
cd ~/DeltaLock
secret_key="$(rake secret)"

echo "SECRET_KEY_BASE=$secret_key" >> .rbenv-vars
echo "DELTALOCK_DATABASE_PASSWORD=\$0v3rFl0w" >> .rbenv-vars

echo -e "${BLUE}rake db:create${NC}"
RAILS_ENV=production rake db:create db:schema:load
echo -e "${BLUE}rake assets:precompile${NC}"
RAILS_ENV=production rake assets:precompile
#RAILS_ENV=production rails server --binding= #PUBLIC IP

echo -e "${BLUE}Installing Unicorn Gem${NC}"
# echo "gem 'unicorn'" >> Gemfile
bundle
cp install/special_files/unicorn.rb config/unicorn.rb
echo -e "${GREEN}Unicorn file installed${NC}"

mkdir -p shared/pids shared/sockets shared/log


exit 0
