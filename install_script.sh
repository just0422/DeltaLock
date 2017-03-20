#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'


echo -e "${BLUE}Running apt-get update${NC}"
apt-get -yq update

pkgs=(git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs)

for pkg in "${pkgs[@]}"
do
	echo -e "${BLUE}Installing $pkg"
	if dpkg -s "$pkg" >/dev/null 2>&1; then
		echo -e "${YELLOW}$pkg already installed"
	elif apt-get -qq -y install "$pkg" >/dev/null 2>&1; then
		echo -e "${GREEN}$pkg sucessfully installed"
	else
		echo -e "\t${RED}$pkg not installed"
	fi
done

pkgs=(autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev)

for pkg in "${pkgs[@]}"
do
	echo -e "${BLUE}Installing $pkg"
	if dpkg -s "$pkg" >/dev/null 2>&1; then
		echo -e "${YELLOW}$pkg already installed"
	elif apt-get -qq -y install "$pkg" >/dev/null 2>&1; then
		echo -e "${GREEN}$pkg sucessfully installed"
	else
		echo -e "\t${RED}$pkg not installed"
	fi
done


echo -e "${BLUE}Config git${NC}"
git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"

cd ~
echo -e "${BLUE}Removing previous .rbenv directory (if it exists)${NC}"
rm -rf .rbenv
echo -e "${BLUE}Cloning rbenv repository${NC}"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo -e "${BLUE}Installing rbenv${NC}"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
if source ~/.bashrc; then
	echo -e "${GREEN}rbenv successfully installed${NC}"
else
	echo -e "${RED}rbenv not installed${NC}"
fi

echo -e "${BLUE}Cloning ruby build into rbenv${NC}"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
echo -e "${BLUE}Installing ruby${NC}"
source ~/.bashrc

rbenv install 2.4.0
rbenv global 2.4.0
if ruby -v; then
	echo -e "${GREEN}Ruby successfully installed${NC}"
else
	echo -e "${RED}Ruby not installed. Abort...${NC}"
	exit 1
fi

exit 0
gem install bundler


gem install rails -v 5.0.1
rbenv rehash
rails -v

cd /tmp
\curl -sSL https://deb.nodesource.com/setup_6.x -o nodejs.sh
less nodejs.sh

cat /tmp/nodejs.sh | sudo -E bash -
apt-get install -y nodejs

cd ~/.rbenv
git pull


cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

cd ~/DeltaLock
rake secret

cat "SECRET_KEY_BASE=your_generated_secret\n" >> .rbenv-vars
cat "APPNAME_DATABASE_PASSWORD=prod_db_pass\n" >> .rbenv-vars



RAILS_ENV=production rake db:create
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rails server --binding= #PUBLIC IP


cat "gem 'unicorn'" >> Gemfile
bundle
cat special_files/unicorn.rb >> confige/unicorn.rb

mkdir -p shared/pids shared/sockets shared/log

cp special_files/unicorn_init.sh /etc/init.d/unicorn_ #APPNAME
chmod 755 /etc/init.d/unicorn_ #APPNAME
update-rc.d unicorn_appname defaults

service unicorn_ #APPNAME start


apt-get install nginx
cp special_files/nginx_config >> /etc/nginx/sites-available/default

service nginx restart




