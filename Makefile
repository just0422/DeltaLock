all: dependencies rails node_mysql db_unicorn unicorn_nginx

dependencies:
	sudo ./install/dependencies.sh

rails:
	./install/rails_install.sh
	source ~/.bashrc

node_mysql:
	sudo ./install/node_mysql.sh

db_unicorn:
	./install/db_unicorn.sh

unicorn_nginx:
	sudo ./install/unicorn_nginx.sh
