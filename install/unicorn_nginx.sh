#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Copying unicorn startup script to /etc/init.d${NC}"
cp install/special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
echo -e "${BLUE}Adjusting unicorn startup script permissions${NC}"
chmod 755 /etc/init.d/unicorn_deltalock
update-rc.d unicorn_deltalock defaults
echo -e "${BLUE}Starting  unicorn${NC}"
service unicorn_deltalock start

if systemctl is-active --quiet unicorn_deltalock
    echo -e "${GREEN}Unicorn Application Servier successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Unicorn. Abort...${NC}"
    exit 1
fi


echo -e "${BLUE}Installing nginx${NC}"
apt-get -yq install nginx >/dev/null

echo -e "${BLUE}Copying configuration file to Nginx${NC}"
cp install/special_files/nginx_config /etc/nginx/sites-available/default
sed -i 's/DELTALOCK_USERNAME_PLACEHOLDER/$DELTAUSER/g' /etc/nginx/sites-available/default

service nginx restart

if systemctl is-active --quiet nginx 
    echo -e "${GREEN}Nginx Servier successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting Nginx. Abort...${NC}"
    exit 1
fi

echo -e "${YELLOW}--------------------------------------------------------"
echo -e "${YELLOW}|${BLUE}       DeltaLock Software ${GREEN}Successfully ${BLUE}Installed!      ${YELLOW}|"
echo -e "${YELLOW}--------------------------------------------------------${NC}"
