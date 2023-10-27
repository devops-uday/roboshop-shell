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

yum module disable mysql -y  &>>$LOGFILE
VALIDATE $? " disabling  mysl default version"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE
VALIDATE $? " copying mysql.repo "

yum install mysql-community-server -y &>>$LOGFILE
VALIDATE $? " installing mysql communtiy server "

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? " enabling mysql "

systemctl start mysqld &>>$LOGFILE
VALIDATE $? " strating mysql "

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE
VALIDATE $? " setting up the root password "

