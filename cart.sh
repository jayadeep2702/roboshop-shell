source common.sh

echo -e "\e[32m>>>>>>>configure node js repo<<<<<<<\e]0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m >>>>>>>installing Nodejs<<<<<<<\e]0m"
yum install nodejs -y


echo -e "\e[32m >>>>>>>add application user<<<<<<<\e]0m"
useradd rob${app_user}

echo -e "\e[32m >>>>>>>crating application directory<<<<<<<\e]0m"
rm -rf /app
mkdir /app

echo -e "\e[32m >>>>>>>downloading App content<<<<<<<\e]0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[32m >>>>>>>unzip app content<<<<<<<\e]0m"
unzip /tmp/cart.zip

echo -e "\e[32m >>>>>>>downloading dependencies<<<<<<<\e]0m"
npm install
echo -e "\e[32m >>>>>>>copying cart service file<<<<<<<\e]0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
echo -e "\e[32m >>>>>>>service cart start<<<<<<<\e]0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart

