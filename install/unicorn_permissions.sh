#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Copying unicorn init script to /etc/init.d${NC}"
cp install/special_files/unicorn_init.sh /etc/init.d/unicorn_deltalock
echo -e "${BLUE}Adjusting unicorn /etc/init.d permissions${NC}"
chmod 755 /etc/init.d/unicorn_deltalock
update-rc.d unicorn_deltalock defaults


echo -e "${BLUE}Installing nginx${NC}"
apt-get -yq install nginx
cp install/special_files/nginx_config /etc/nginx/sites-available/default
service nginx restart

