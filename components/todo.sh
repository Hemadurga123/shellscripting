#!/bin/bash

source components/common.sh
OS_PREREQ
DN="eshwarzelarsoft.host"

Head "Installing npm"
apt install npm -y &>>$LOG
Check $?

DOWNLOAD_COMPONENT

Head "Extract Downloaded Archive"
cd /home/ubuntu && rm -rf todo && apt install -y  unzip && unzip -o /tmp/todo.zip &>>$LOG && mv todo-main todo  && cd todo && npm install &>>$LOG

Check $?

Head "pass the EndPoints in Service File"
sed -i -e "s/redis-endpoint/redis.${DN}/" /home/ubuntu/todo/systemd.service
Check $?


Head "Setuping  the systemd Service"
mv /home/ubuntu/todo/systemd.service /etc/systemd/system/todo.service && systemctl daemon-reload && systemctl start todo && systemctl enable todo &>>$LOG
Check $?
