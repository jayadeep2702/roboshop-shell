script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_passwd=$1
echo -e "\e[32m >>>>>>>install Maven<<<<<<<\e]0m"
yum install maven -y
echo -e "\e[32m >>>>>>>add user for application<<<<<<<\e]0m"
useradd ${app_user}
echo -e "\e[32m >>>>>>>create directory<<<<<<<\e]0m"
mkdir /app
echo -e "\e[32m >>>>>>>download application content<<<<<<<\e]0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
echo -e "\e[32m >>>>>>>unzip app content<<<<<<<\e]0m"
unzip /tmp/shipping.zip
cd /app
echo -e "\e[32m >>>>>>>download dependencies<<<<<<<\e]0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[32m >>>>>>>copy shipping service file<<<<<<<\e]0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[32m >>>>>>>install mysql<<<<<<<\e]0m"
yum install mysql -y
echo -e "\e[32m >>>>>>>load schema for mysql<<<<<<<\e]0m"
mysql -h mysql-dev.jdevops72.online -uroot -p${mysql-_root_passwd} < /app/schema/shipping.sql
echo -e "\e[32m >>>>>>>start shipping service<<<<<<<\e]0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping