echo -e "\e["32m >>>>>>>configure node js repo<<<<<<<\e]0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e["32m >>>>>>>installing Nodejs<<<<<<<\e]0m"
yum install nodejs -y

echo -e "\e["32m >>>>>>>add application user<<<<<<<\e]0m"
useradd roboshop

echo -e "\e["32m >>>>>>>crating application directory<<<<<<<\e]0m"
mkdir /app

echo -e "\e["32m >>>>>>>downloading App content<<<<<<<\e]0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e["32m >>>>>>>unzip app content<<<<<<<\e]0m"
unzip /tmp/catalogue.zip

echo -e "\e["32m >>>>>>>downloading dependencies<<<<<<<\e]0m"
npm install

echo -e "\e["32m >>>>>>>copy catalogue.service file<<<<<<<\e]0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e["32m >>>>>>>start catalogue service<<<<<<<\e]0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e["32m >>>>>>>copy mongo.repo file<<<<<<<\e]0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e["32m >>>>>>>Installing mongodb<<<<<<<\e]0m"
yum install mongodb-org-shell -y

echo -e "\e["32m >>>>>>>load schema for mongodb<<<<<<<\e]0m"
mongo --host mongo-dev.jdevops72.online </app/schema/catalogue.js