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
		echo -e "${RED}$2 not installed${NC}. Aborting..."
		exit 1
	fi
}

echo -e "${BLUE}Installing Node.js${NC}"
sleep 1
apt-get install -qq nodejs
install 'nodejs -v' 'Node.js'

## Make sure DB is Setup HERE***********************************
echo -e "${BLUE}Checking to see if MySQL is installed${NC}"
if mysql --version; then
	echo -e "${GREEN}MySQL is already installed!"
else
	echo -e "${RED}MySQL is not installed${NC}"
	echo -e "${BLUE}Installing MySQL${NC}"
	sleep 1

	apt-get install -qq mysql-server mysql-client libmysqlclient-dev >/dev/null
	mysql_install_db
	mysql_secure_installation
	echo -e "${GREEN}MySQL successfully installed!"
fi

echo -e "${BLUE}Starting MySQL${NC}"
service mysql start
if systemctl is-active --quiet mysql; then
    echo -e "${GREEN}MySQL successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting MySQL. Abort...${NC}"
    exit 1
fi

echo -e "\n${BLUE}Creating DeltaLock MySQL user (different than root created before)${NC}"
printf "${YELLOW}Please enter DeltaLock MySQL username:${NC} "
read deltauser
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

mysql_config_editor remove --login-path=root
echo -e "\n\n${YELLOW}Please enter root user MySQL password. This is the same one entered when the screen turned pink. ${NC}"
mysql_config_editor set --login-path=root --host=localhost --user=root --password

echo -e "${BLUE}Createing rails MySQL user${NC}"
mysql --login-path=root -e "GRANT ALL PRIVILEGES ON *.* TO '${deltauser}'@'localhost' IDENTIFIED BY '${deltapass}';"

USER_EXISTS="$(mysql --login-path=root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user ='${deltauser}')")"
if [ "$USER_EXISTS" = 1 ]; then
    echo -e "${BLUE}${deltauser} ${GREEN}successfully created!"
else
    echo -e "${RED}There was an issue creating user. Abort..."
    exit 1
fi

echo "export DELTAUSER=${deltauser}" >> ~/.bashrc
echo "export DELTAPASS=${deltapass}" >> ~/.bashrc
echo "export DELTAUSER=${deltauser}" >> ~/.profile
echo "export DELTAPASS=${deltapass}" >> ~/.profile

export "DELTAUSER=${deltauser}"
export "DELTAPASS=${deltapass}"

source ~/.bashrc
