#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

printf "${YELLOW}Please enter your username:${NC} "
read username

echo -e "${BLUE}Copying unicorn startup script to /etc/init.d${NC}"
sleep 1
cp install/special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
sed -i 's/DELTALOCK_USERNAME_PLACEHOLDER/'"${username}"'/g' /etc/init.d/unicorn_deltalock
sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/init.d/unicorn_deltalock
echo -e "${GREEN}Copied unicorn startup script successfully${NC}"

echo -e "\n${BLUE}Adjusting unicorn startup script permissions${NC}"
sleep 1
chmod 755 /etc/init.d/unicorn_deltalock
update-rc.d unicorn_deltalock defaults
echo -e "\n${GREEN}Adjusting permissions successfully${NC}"

echo -e "${BLUE}Starting  unicorn${NC}"
service unicorn_deltalock start

if systemctl is-active --quiet unicorn_deltalock; then
    echo -e "${GREEN}Unicorn Application Servier successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Unicorn. Abort...${NC}"
    exit 1
fi

echo -e "${BLUE}Installing nginx${NC}"
apt-get -qq install nginx
echo -e "${GREEN}Installed nginx${NC}"

echo -e "${BLUE}Copying configuration file to Nginx${NC}"
cp install/special_files/nginx_config /etc/nginx/sites-available/default
sed -i 's?APPLICATION_ROOT_DIRECTORY?'"$PWD"'?g' /etc/nginx/sites-available/default
echo -e "${GREEN}Copied configuration file sucessfully${NC}"

echo -e "${BLUE}Starting Nginx server${NC}"
service nginx restart

if systemctl is-active --quiet nginx; then
    echo -e "${GREEN}Nginx Server successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Nginx. Abort...${NC}"
    exit 1
fi

echo -e "${YELLOW}--------------------------------------------------------"
echo -e "${YELLOW}|${BLUE}       DeltaLock Software ${GREEN}Successfully ${BLUE}Installed!      ${YELLOW}|"
echo -e "${YELLOW}--------------------------------------------------------${NC}"
