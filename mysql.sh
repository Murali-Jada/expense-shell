#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
         echo -e "$2...$R FAILURE $N"
         exit 1
    else
         echo -e "$2...$G SUCCESS $N"
    fi      
}

if [ $USERID -ne 0 ]
then 
    echo "please run the script with root access"
    exit 1 # manually exit if error comes
else
    echo "you are super user"
fi 

dnf install mysql-server -y &>>$LOGFILE 
VALIDATE $? "Installing MYSQL server" 

systemctl enable mysqld &>>$LOGFILE 
VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting MYSQL server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE 
# VALIDATE $? "setting up root password" 

#Below code useful for idempotent nature

 mysql -h db.daws78.online  -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE 
 if [ $? -ne 0 ]
 then 
     echo "mysql_secure_installation --set-root-pass ExpenseApp@1"
     VALIDATE $? "MYSQL root pasword setup"
 else 
     echo -e "MYSQL Root password already setup...$Y SKIPPING $N"  
 fi       