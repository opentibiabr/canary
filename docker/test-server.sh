#!/bin/bash

# set -o xtrace
set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

export DEBIAN_FRONTEND=noninteractive

ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

apt-get update
apt-get install -y \
	apache2 \
	build-essential \
	ca-certificates \
	ccache \
	cmake \
	curl \
	git \
	libapache2-mod-php \
	libluajit-5.1-dev \
	php \
	php-mysql \
	pkg-config \
	python3 \
	python3-pip \
	tar \
	unzip \
	zip

dpkg-reconfigure --frontend noninteractive tzdata

apt-get install -y mariadb-server mariadb-client
/etc/init.d/mysql start

apt-get install -y phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html
/etc/init.d/apache2 start

# Create database and import schema
mysql -u root -e "CREATE DATABASE $DB_DATABASE;"
mysql -u root -e "SHOW DATABASES;"
mysql -u root -D $DB_DATABASE < schema.sql
mysql -u root -D $DB_DATABASE < docker/data/01-test_account.sql
mysql -u root -D $DB_DATABASE < docker/data/02-test_account_players.sql

# Create user
mysql -u root -e "CREATE USER '$DB_USER'@localhost IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -e "SELECT User FROM mysql.user;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@localhost IDENTIFIED BY '$DB_PASSWORD';"

# Make our changes take effect
mysql -u root -e "FLUSH PRIVILEGES;"

pip3 install --no-cache-dir Flask mysql-connector-python
python3 docker/data/login.py &

git clone https://github.com/microsoft/vcpkg
cd vcpkg
./bootstrap-vcpkg.sh
cd ..

mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake ..
make -j`nproc`
mv bin/otbr ../
cd ..

unzip -o data/world/world.zip -d data/world/

cp config.lua.dist config.lua
sed -i '/ip = .*$/c\ip = "'"$PROXY_IP"'"' config.lua
sed -i '/motd = .*$/c\motd = "Test Server"' config.lua
sed -i '/mysqlHost = .*$/c\mysqlHost = "'"$DB_IP"'"' config.lua
sed -i '/mysqlUser = .*$/c\mysqlUser = "'"$DB_USER"'"' config.lua
sed -i '/mysqlPass = .*$/c\mysqlPass = "'"$DB_PASSWORD"'"' config.lua
sed -i '/mysqlDatabase = .*$/c\mysqlDatabase = "'"$DB_DATABASE"'"' config.lua
sed -i '/onePlayerOnlinePerAccount = .*$/c\onePlayerOnlinePerAccount = false' config.lua
sed -i '/serverSaveShutdown = .*$/c\serverSaveShutdown = false' config.lua
