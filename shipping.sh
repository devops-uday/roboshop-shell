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

yum install maven -y &>>$LOGFILE
VALIDATE $? " installing maven "

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE
VALIDATE $? " downloading shipping artifact "

cd /app &>>$LOGFILE
VALIDATE $?  " changing into app directory "

unzip /tmp/shipping.zip &>>$LOGFILE
VALIDATE $? " unzipping shipping "

cd /app &>>$LOGFILE
VALIDATE $? " changing into app directory "

mvn clean package &>>$LOGFILE
VALIDATE $? " packaging shipping app "

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE 
VALIDATE $? " renaming shipping jar "

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE 
VALIDATE $? " copying shipping service "

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? " daemon reload shipping "

systemctl enable shipping  &>>$LOGFILE
VALIDATE $? " enabling shipping "

systemctl start shipping &>>$LOGFILE
VALIDATE $? " starting shipping " 

yum install mysql -y  &>>$LOGFILE 
VALIDATE $? " installing mysql client "

mysql -h 172.31.16.126 -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$LOGFILE 
VALIDATE $? " loading countries and cities information "

systemctl restart shipping &>>$LOGFILE 
VALIDATE $? " restarting shipping "