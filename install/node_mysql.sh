#!/bin/bash

. ./install/rails_install.sh

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

## Make sure DB is Setup HERE***********************************

echo -e "${BLUE}Starting MySQL${NC}"
sudo service mysql start
sleep 1
if sudo systemctl is-active --quiet mysql; then
    echo -e "${GREEN}MySQL successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting MySQL. Abort...${NC}"
    exit 1
fi

sleep 1
echo -e "\n${BLUE}Ruby on rails suggests creating another user specifically for the application. For security, this user is different than root.${NC}"
printf "${YELLOW}Please enter DeltaLock MySQL username:${NC} "
read deltauser
while [ "$deltauser" = "root" ]; do
    echo -e "\n\n${RED}Cannot use 'root' username"
    printf "${YELLOW}Please enter DeltaLock MySQL username:${NC} "
    read deltauser
done

printf "${YELLOW}Please enter DeltaLock MySQL password:${NC} "
read -s deltapass
printf "\n${YELLOW}Please confirm DeltaLock MySQL password:${NC} "
read -s deltapassConfirm

while [ "$deltapass" != "$deltapassConfirm" ]; do
    echo -e "\n\n${RED}Passwords do not match. Please try again..."
    printf "${YELLOW}Please enter DeltaLock MySQL password:${NC} "
    read -s deltapass
    printf "\n${YELLOW}Please confirm DeltaLock MySQL password:${NC} "
    read -s deltapassConfirm
done

sudo mysql_config_editor remove --login-path=root
echo -e "\n\n${YELLOW}Please enter root user MySQL password. This is the same one entered when the screen turned pink. ${NC}"
sudo mysql_config_editor set --login-path=root --host=localhost --user=root --password

echo -e "${BLUE}Createing rails MySQL user${NC}"
sudo mysql --login-path=root -e "GRANT ALL PRIVILEGES ON *.* TO '${deltauser}'@'localhost' IDENTIFIED BY '${deltapass}';"

USER_EXISTS="$(mysql --login-path=root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user ='${deltauser}')")"
if [ "$USER_EXISTS" = 1 ]; then
    echo -e "${BLUE}${deltauser} ${GREEN}successfully created!"
else
    echo -e "${RED}There was an issue creating user. Abort..."
    exit 1
fi

echo "export DELTAUSER=${deltauser}" >> ~/.bashrc
echo "export DELTAPASS=${deltapass}" >> ~/.bashrc

export DELTAUSER="${deltauser}"
export DELTAPASS="${deltapass}"

