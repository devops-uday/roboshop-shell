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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? " congiguring repos from vendors "

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? " " configuring repos for rabbitmq "

yum install rabbitmq-server -y  &>>$LOGFILE
VALIDATE $? " installing rabbitmq "

systemctl enable rabbitmq-server  &>>$LOGFILE
VALIDATE $? " enabling rabbitmq "

systemctl start rabbitmq-server  &>>$LOGFILE
VALIDATE $? " strating rabbitmq "

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
VALIDATE $? " adding user "

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? " setting permissions to rabbitmq "
