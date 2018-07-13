#!/bin/bash

sudo ./install/dependencies.sh

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
sleep 1
#source ~/.bashrc
rbenv install --verbose 2.3.1
rbenv global 2.3.1
install 'ruby -v' 'ruby'

echo -e "${BLUE}Installing bundle${NC}"
sleep 0.25
install 'gem install --verbose bundler' 'bundle'

echo -e "${BLUE}Installing Rails (this will take a while too..)${NC}"
sleep 1
gem install --verbose rails -v 4.2.6
rbenv rehash
install 'rails -v' 'Rails'

