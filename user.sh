source common.sh

echo -e "\e[32m>>>>>>>configure node js repo<<<<<<<\e]0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m >>>>>>>installing Nodejs<<<<<<<\e]0m"
yum install nodejs -y


echo -e "\e[32m >>>>>>>add application user<<<<<<<\e]0m"
useradd ${a--_user}

echo -e "\e[32m >>>>>>>crating application directory<<<<<<<\e]0m"
rm -rf /app
mkdir /app

echo -e "\e[32m >>>>>>>downloading App content<<<<<<<\e]0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[32m >>>>>>>unzip app content<<<<<<<\e]0m"
unzip /tmp/user.zip

echo -e "\e[32m >>>>>>>downloading dependencies<<<<<<<\e]0m"
npm install
echo -e "\e[32m >>>>>>>copy user service file<<<<<<<\e]0m"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
echo -e "\e[32m >>>>>>>start user service<<<<<<<\e]0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user
echo -e "\e[32m >>>>>>>copy mongo repo<<<<<<<\e]0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[32m >>>>>>>installing mongodb client<<<<<<<\e]0m"
yum install mongodb-org-shell -y

echo -e "\e[32m >>>>>>>load mongodb schema<<<<<<<\e]0m"
mongo --host mongodb-dev.jdevops72.online </app/schema/user.js