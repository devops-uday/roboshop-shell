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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
VALIDATE $? " Installing Redis Repo "

yum module enable redis:remi-6.2 -y &>>$LOGFILE
VALIDATE $? " Enabling Redis 6.2"

yum install redis -y &>>$LOGFILE
VALIDATE $? " Installing Redis "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE
VALIDATE $? " editing Redis.config "

systemctl enable redis &>>$LOGFILE
VALIDATE $? " Enabling Redis "

systemctl start redis &>>$LOGFILE
VALIDATE $? " Starting Redis"
