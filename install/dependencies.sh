#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Running apt-get update${NC}"
apt-get -qq update 
echo -e "${GREEN}Packages updated sucessfully${NC}"

pkgs=(git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs)

for pkg in "${pkgs[@]}"
do
	echo -e "${BLUE}Installing $pkg${NC}"
	if dpkg -s "$pkg" >/dev/null; then
		echo -e "${YELLOW}$pkg already installed${NC}"
	elif apt-get -qq -y install "$pkg"; then
		echo -e "${GREEN}$pkg sucessfully installed${NC}"
	else
		echo -e "\t${RED}$pkg not installed${NC}"
	fi

	sleep 0.25
done

pkgs=(autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev)

for pkg in "${pkgs[@]}"
do
	echo -e "${BLUE}Installing $pkg${NC}"
	if dpkg -s "$pkg" >/dev/null; then
		echo -e "${YELLOW}$pkg already installed${NC}"
	elif apt-get -qq -y install "$pkg"; then
		echo -e "${GREEN}$pkg sucessfully installed${NC}"
	else
		echo -e "\t${RED}$pkg not installed${NC}"
	fi

	sleep 0.25
done


