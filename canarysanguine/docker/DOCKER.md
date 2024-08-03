# Getting Started with docker

## - Requirements
- Docker 19 and docker-compose 1.17
- Execute the script root directory /docker/data/download-myaac.sh
- To use global ip change the login.py on world to use that ip and
also change in config.lua.dist
- Client pointing to http://<ip>:8080/login.php

### Default Values (docker-compose.yml)
- Ports: 7171, 7172, 80(web), 3306, 8080(login)
- Database Server: database
- Database Name/User/Password: otserver

### - Commands
To compile and start database, webserver and otserver just run
```
$ docker-compose up -d
```
Sometimes the server will not start due to database take too long to start
so you can restart it
```
docker-compose restart otserver

or

docker-compose stop otserver
docker-compose start otserver
```

To compile your changes in otserver, just stop and start
```
$ docker-compose up -d --build otserver
```

### - Observations
- The data folder persist db and webserver data;
