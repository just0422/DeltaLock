#!/bin/bash
echo -e "${BLUE}Install Node.js${NC}"
apt-add-repository ppa:chris-lea/node.js
apt-get install -yq nodejs

## Make sure DB is Setup HERE***********************************
echo -e "${BLUE}Checking to see if MySQL is installed${NC}"
if mysql --version; then
	echo -e "${GREEN}MySQL is installed!"
else
	echo -e "${RED}MySQL is not installed${NC}"
	echo -e "${BLUE}Installing MySQL${NC}"

	apt-get install -y mysql-server mysql-client libmysqlclient-dev
	mysql_install_db
	mysql_secure_installation
fi
service mysql start

