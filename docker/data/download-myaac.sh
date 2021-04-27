#!/usr/bin/env bash

wget https://github.com/slawkens/myaac/archive/master.zip -O myaac.zip
unzip -o myaac.zip -d .

mv myaac-master/* ./web
rm myaac.zip myaac-master -rf

wget https://github.com/opentibiabr/myaac-tibia12-login/archive/refs/heads/develop.zip -O myaac-otbr-plugin.zip
unzip -o myaac-otbr-plugin.zip -d .

cp -r myaac-tibia12-login-develop/* ./web
rm -rf myaac-otbr-plugin.zip myaac-tibia12-login-develop