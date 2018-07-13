#!/bin/bash

source ~/.bashrc

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

printf "${YELLOW}Please enter your username:${NC} "
read username

echo -e "\n${BLUE}Installing Unicorn configuration file${NC}"
sleep 0.1
cp install/special_files/unicorn.rb config/unicorn.rb
echo -e "${GREEN}Unicorn file configuration installed${NC}"

mkdir -p shared/pids shared/sockets shared/log
echo -e "${BLUE}Copying unicorn startup script to /etc/init.d${NC}"
sleep 1
sudo cp install/special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
sudo sed -i 's/DELTALOCK_USERNAME_PLACEHOLDER/'"${username}"'/g' /etc/init.d/unicorn_deltalock
sudo sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/init.d/unicorn_deltalock
echo -e "${GREEN}Copied unicorn startup script successfully${NC}"

echo -e "\n${BLUE}Adjusting unicorn startup script permissions${NC}"
sleep 1
sudo chmod 755 /etc/init.d/unicorn_deltalock
sudo update-rc.d unicorn_deltalock defaults
echo -e "\n${GREEN}Adjusting permissions successfully${NC}"

echo -e "${BLUE}Starting  unicorn${NC}"
sudo service unicorn_deltalock start

if sudo systemctl is-active --quiet unicorn_deltalock; then
    echo -e "${GREEN}Unicorn Application Servier successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Unicorn. Abort...${NC}"
    exit 1
fi

echo -e "${BLUE}Copying configuration file to Nginx${NC}"
sudo cp install/special_files/nginx_config /etc/nginx/sites-available/default
sudo sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/nginx/sites-available/default
echo -e "${GREEN}Copied configuration file sucessfully${NC}"

echo -e "${BLUE}Starting Nginx server${NC}"
sudo service nginx restart

if sudo systemctl is-active --quiet nginx; then
    echo -e "${GREEN}Nginx Server successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Nginx. Abort...${NC}"
    exit 1
fi

echo -e "${YELLOW}--------------------------------------------------------"
echo -e "${YELLOW}|${BLUE}       DeltaLock Software ${GREEN}Successfully ${BLUE}Installed!      ${YELLOW}|"
echo -e "${YELLOW}--------------------------------------------------------${NC}"
