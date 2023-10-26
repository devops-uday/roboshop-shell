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

yum install nginx -y &>>$LOGFILE
VALIDATE $? " installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? " enabling nginx "

systemctl start nginx &>>$LOGFILE
VALIDATE $? " starting nginx "

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? " removing default html file"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? " downloding new html "

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? " moving into html folder"

unzip /tmp/web.zip &>>$LOGFILE
VALIDATE$? " unzipping html file"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE 
VALIDATE $? " copying roboshop.conf"

systemctl restart nginx  &>>$LOGFILE
VALIDATE $? " restarting nginx"
