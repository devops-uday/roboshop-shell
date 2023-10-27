#!/bin/bash

USERID=$(id -u)
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Please run the code with sudo access $N"
    exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2....$R FAILURE $N"
        exit 1
    else 
        echo -e "  $2.....$G SUCCESS $N"
    fi
}

yum install maven -y

useradd roboshop

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app

unzip /tmp/shipping.zip

cd /app

mvn clean package

mv target/shipping-1.0.jar shipping.jar

/etc/systemd/system/shipping.service

systemctl daemon-reload

systemctl enable shipping 

systemctl start shipping

yum install mysql -y 

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping