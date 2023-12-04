/$0-$DATE.log

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
    if [ $1 -ne 0 

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? " removing default html file"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? " downloding new html "

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? " moving into html folder"

unzip /tmp/web.zip &>>$LOGFILE
VALIDATE $? " unzipping html file"

cp /h