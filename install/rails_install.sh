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

echo -e "${BLUE}Configuring git...${NC}"
git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"
git config --global push.default matching
echo -e "${GREEN}Git configuration successful!${NC}"

cd ~
echo -e "${BLUE}Removing previous .rbenv directory (if it exists)${NC}"
rm -rf .rbenv
echo -e "${BLUE}Cloning rbenv repository${NC}"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo -e "${BLUE}Installing rbenv${NC}"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.profile
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
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.profile
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

