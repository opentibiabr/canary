#!/usr/bin/env bash

wget https://github.com/opentibiabr/myaac/archive/refs/heads/main.zip -O myaac.zip
unzip -o myaac.zip -d .

mv myaac-master/* ./web
rm myaac.zip myaac-master -rf

wget https://github.com/opentibiabr/myaac-tibia12-login/archive/refs/heads/main.zip -O myaac-otbr-plugin.zip
unzip -o myaac-otbr-plugin.zip -d myaac-tibia12-login-main/

cp -r myaac-tibia12-login-main/* ./web
rm -rf myaac-otbr-plugin.zip myaac-tibia12-login-main