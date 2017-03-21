#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

function install(){
	if $1; then
		echo -e "${GREEN}$2 successfully installed${NC}"
	else
		echo -e "${RED}$2 not installed${NC}"
		exit 1
	fi
}

echo -e "${BLUE}Config git${NC}"
git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"
git config --global push.default matching

cd ~
echo -e "${BLUE}Removing previous .rbenv directory (if it exists)${NC}"
rm -rf .rbenv
echo -e "${BLUE}Cloning rbenv repository${NC}"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo -e "${BLUE}Installing rbenv${NC}"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
#install 'source ~/.bashrc'
#if source ~/.bashrc; then
#	echo -e "${GREEN}rbenv successfully installed${NC}"
#else
#	echo -e "${RED}rbenv not installed${NC}"
#fi

echo -e "${BLUE}Cloning ruby build into rbenv${NC}"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
echo -e "${BLUE}Installing ruby${NC}"
#source ~/.bashrc

rbenv install 2.3.1
rbenv global 2.3.1
install 'ruby -v' 'ruby'
#if ruby -v; then
#	echo -e "${GREEN}Ruby successfully installed${NC}"
#else
#	echo -e "${RED}Ruby not installed. Abort...${NC}"
#	exit 1
#fi


echo -e "${BLUE}Installing bundle${NC}"
install 'gem install bundler' 'bundle'


echo -e "${BLUE}Install Rails${NC}"
gem install rails -v 4.2.6
rbenv rehash
install 'rails -v' 'Rails'

echo -e "${BLUE}Install Node.js${NC}"
apt-add-repository ppa:chris-lea/node.js
apt-get install -yq nodejs

## Make sure DB is Setup HERE***********************************

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
exit 0

echo "SECRET_KEY_BASE=$secret_key\n" >> .rbenv-vars
echo "APPNAME_DATABASE_PASSWORD=prod_db_pass\n" >> .rbenv-vars



RAILS_ENV=production rake db:create
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rails server --binding= #PUBLIC IP


echo "gem 'unicorn'" >> Gemfile
bundle
echo special_files/unicorn.rb >> confige/unicorn.rb

mkdir -p shared/pids shared/sockets shared/log

cp special_files/unicorn_init.sh /etc/init.d/unicorn_ #APPNAME
chmod 755 /etc/init.d/unicorn_ #APPNAME
update-rc.d unicorn_appname defaults

service unicorn_ #APPNAME start


apt-get install nginx
cp special_files/nginx_config >> /etc/nginx/sites-available/default

service nginx restart
