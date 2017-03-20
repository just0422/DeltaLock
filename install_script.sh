apt-get update
apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs
apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev



git config --global color.ui true
git config --global user.name "DeltaLock"
git config --global user.email "delta@deltalock.biz"

cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.4.0
rbenv global 2.4.0
ruby -v


gem install bundler


gem install rails -v 5.0.1
rbenv rehash
rails -v

cd /tmp
\curl -sSL https://deb.nodesource.com/setup_6.x -o nodejs.sh
less nodejs.sh

cat /tmp/nodejs.sh | sudo -E bash -
apt-get install -y nodejs

cd ~/.rbenv
git pull


cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git

cd ~/DeltaLock
rake secret

cat "SECRET_KEY_BASE=your_generated_secret\n" >> .rbenv-vars
cat "APPNAME_DATABASE_PASSWORD=prod_db_pass\n" >> .rbenv-vars



RAILS_ENV=production rake db:create
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rails server --binding= #PUBLIC IP


cat "gem 'unicorn'" >> Gemfile
bundle
cat special_files/unicorn.rb >> confige/unicorn.rb

mkdir -p shared/pids shared/sockets shared/log

cp special_files/unicorn_init.sh /etc/init.d/unicorn_ #APPNAME
chmod 755 /etc/init.d/unicorn_ #APPNAME
update-rc.d unicorn_appname defaults

service unicorn_ #APPNAME start


apt-get install nginx
cp special_files/nginx_config >> /etc/nginx/sites-available/default

service nginx restart




