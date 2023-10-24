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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
VALIDATE $? "settingup NPM Source"

yum install nodejs -y &>> $LOGFILE
VALIDATE $? " Installing nodeJS"

#Once the user is created, if you run the script second time 
#This command will definitely fail
#IMPROVEMENT Fisrt check the User already exist or not, if not exist then create
useradd roboshop &>> $LOGFILE

#Write a condition to check whether the directory already exist or not
mkdir /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? " Downloading Catalouge artifact"

cd /app &>> $LOGFILE
VALIDATE $? "Moving into app directory"

unzip /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "   Unzipping catalouge"

cd /app &>> $LOGFILE
VALIDATE $? " Moving into app directory"

npm install &>> $LOGFILE
VALIDATE $? " Installing dependencies NPM"

#Give full path of catalouge.service because we are inside /app folder
cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? " Copying Catalouge.service" 

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? " Daemon-Reloading"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? " Enabling Catalouge"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? " Starting Catalouge "

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? " Copying MongoDB.repo"

yum install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? " Installing MongoDB Client Org-Shell"

mongo --host mongodb.devopsuday.online </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? " Loading Schema Catalouge data into mongodb "

