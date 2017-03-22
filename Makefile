all: dependencies rails node_mysql unicorn_nginx

dependencies:
	sudo ./install/dependencies.sh

rails:
	./install/rails_install.sh

node_mysql:
	sudo ./install/node_mysql.sh

unicorn_nginx:
	./install/unicorn_nginx_install.sh
