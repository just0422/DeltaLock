# Each script begins the previous script before it starts it's own
all: unicorn_nginx

dependencies:
	sudo ./install/dependencies.sh

rails:
	./install/rails_install.sh

node_mysql:
	sudo ./install/node_mysql.sh

application:
	./install/application.sh

unicorn_nginx:
	sudo ./install/unicorn_nginx.sh
