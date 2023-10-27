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

yum install python36 gcc python3-devel -y &>>$LOGFILE
VALIDATE $? " installing pyhton "

useradd roboshop &>>$LOGFILE

mkdir /app  &>>$LOGFILE 

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE
VALIDATE $? " downloading artifact "

cd /app &>>$LOGFILE
VALIDATE $? " changing to app dircetory "

unzip /tmp/payment.zip &>>$LOGFILE
VALIDATE $? " unzipping payment arifact "

cd /app &>>$LOGFILE
VALIDATE $? " chaniging into app directory "
 
pip3.6 install -r requirements.txt &>>$LOGFILE
VALIDATE $? " installing dependencies "

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
VALIDATE $? " copying payment.service "

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? " reloading payment "

systemctl enable payment  &>>$LOGFILE
VALIDATE $? " enabling payment "

systemctl start payment &>>$LOGFILE
VALIDATE $? " starting payment "