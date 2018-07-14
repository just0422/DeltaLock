# Each script begins the previous script before it starts it's own
all: production 

production:
	./install/production.sh

develop:
	./install/develop.sh
