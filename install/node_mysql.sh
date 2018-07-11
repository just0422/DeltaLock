#!/bin/bash
echo -e "${BLUE}Install Node.js${NC}"
apt-add-repository ppa:chris-lea/node.js
apt-get install -yq nodejs

## Make sure DB is Setup HERE***********************************
echo -e "${BLUE}Checking to see if MySQL is installed${NC}"
if mysql --version; then
	echo -e "${GREEN}MySQL is already installed!"
else
	echo -e "${RED}MySQL is not installed${NC}"
	echo -e "${BLUE}Installing MySQL${NC}"

	apt-get install -y mysql-server mysql-client libmysqlclient-dev
	mysql_install_db
	mysql_secure_installation
	echo -e "${GREEN}MySQL successfully installed!"
fi

echo -e "${BLUE}Starting MySQL${NC}"
service mysql start
if systemctl is-active --quiet mysql
    echo -e "${GREEN}MySQL successfully started!${NC}"
else
    echo -e "${RED}There was an issue starting MySQL. Abort...${NC}"
    exit 1
fi

echo -e "\n${BLUE}Creating DeltaLock MySQL user (different than root created before)${NC}"
echo -e "${BLUE}Please enter DeltaLock MySQL username:${NC}"
read deltauser
echo -e "${BLUE}Please enter DeltaLock MySQL password:${NC}"
read deltapass

echo -e "${BLUE}Please enter MySQL root password (same as install):${NC}"
read rootpass

echo -e "${BLUE}Createing rails MySQL user${NC}"
mysql -uroot -p${rootpass} "GRANT ALL PRIVILEGES ON *.* TO '${deltauser}'@'localhost' IDENTIFIED BY '${deltapass}';"

USER_EXISTS="$(mysql -uroot -p${rootpass} -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user ='${deltauser}')")"

if [ "$USER_EXISTS" = 1]; then
    echo "${BLUE}${deltauser} ${GREEN}successfully created!"
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
