#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


PACKAGES=("git" "docker") 

LOG=docker-install.log

is_package_installed(){
    rpm -q "$1" &>> $LOG
}

install_package(){
    if ! is_package_installed "$1"; then 
        echo "$Y Installing $1... $N"
        sudo yum install -y "$1"
        if [ $? -eq 0 ]; then 
             echo "$G $1 installed succesfully.... $N"
        else 
            echo "$R Error installing in $1... $N"
        fi
    else 
        echo "$G $1 is installed alredy.... $N"
    fi
}

for package in "${PACKAGES[@]}"; do 
    install_package "$package"
done 

echo "All packages and dependencies installed successfully."

VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "$2 ... $R FAILED $N"
		exit 1
	else
		echo -e "$2 ... $G SUCCESS $N"
	fi
}

## docker demon start 
sudo systemctl start docker &>> $LOG
validate $? "docker demon start"

## give persmissions to doker.sock 
sudo chown root:docker /var/run/docker.sock &>> $LOG
validate $? "chown to docker.sock provide"

## Add user to docker group
sudo usermod -aG docker $USER &>> $LOG
validate $? "User added to docker group"

## Re-start docker 
sudo systemctl restart docker &>> $LOG
validate $? "docker restart"

## sudowm 
exit 



