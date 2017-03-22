all: dependencies rails node_mysql db_unicorn 

dependencies:
	sudo ./install/dependencies.sh

rails:
	./install/rails_install.sh

node_mysql:
	sudo ./install/node_mysql.sh

db_unicorn:
	./install/db_unicorn_install.sh
	sudo ./install/unicorn_permissions.sh
