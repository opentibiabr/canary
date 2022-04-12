#!/usr/bin/env bash

wget https://github.com/slawkens/myaac/archive/master.zip -O myaac.zip
unzip -o myaac.zip -d .

mv myaac-master/* ./web
rm -rf myaac.zip myaac-master

wget https://github.com/opentibiabr/myaac-tibia12-login/releases/download/2.0/myaac-tibia12-login-v2.0.zip -O myaac-otbr-plugin.zip
unzip -o myaac-otbr-plugin.zip -d myaac-tibia12-login-master/

cp -r myaac-tibia12-login-master/* ./web
rm -rf myaac-otbr-plugin.zip myaac-tibia12-login-master
