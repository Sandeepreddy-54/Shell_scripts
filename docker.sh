#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG=docker-install.log
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
	echo  -e "$R You are not the root user, you dont have permissions to run this $N"
	exit 1
fi

validate(){
    if [$1 -ne 0]; then 
        echo -e "$2 ... $R Failed $N"
        exit 1
    else; 
        echo -e "$2... $G Success $N"
    fi
}

## Docker install 
sudo yum install docker 
validate $? "docker installed"

## docker demon start 
sudo systemctl start docker
validate $? "docker demon start "

## Add user to docker group
sudo usermod -aG docker $USER
validate $? "User added to docker group"

## Re-start docker 
sudo systemctl restart docker
validate $? "docker restart"

## give persmissions to doker.sock 
sodo chown root:docker /var/run/docker.sock
validate $? "chown to docker.sock provide"

## sudowm 
exit 



