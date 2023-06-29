source common.sh

echo -e "\e[32m >>>>>>>install python<<<<<<<\e]0m"
yum install python36 gcc python3-devel -y
echo -e "\e[32m >>>>>>>add user for the app<<<<<<<\e]0m"
useradd ${app_user}
echo -e "\e[32m >>>>>>>create a directory<<<<<<<\e]0m"
mkdir /app
echo -e "\e[32m >>>>>>>download app content<<<<<<<\e]0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
echo -e "\e[32m >>>>>>>unzip app content<<<<<<<\e]0m"
unzip /tmp/payment.zip
cd /app
echo -e "\e[32m >>>>>>>download dependencies<<<<<<<\e]0m"
pip3.6 install -r requirements.txt
echo -e "\e[32m >>>>>>>copy payment service file<<<<<<<\e]0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
echo -e "\e[32m >>>>>>>start payment service<<<<<<<\e]0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment