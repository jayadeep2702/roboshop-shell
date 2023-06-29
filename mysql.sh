script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m >>>>>>>Disable mysql 8 version<<<<<<<\e]0m"
yum module disable mysql -y
echo -e "\e[32m >>>>>>>configuring mysql repo<<<<<<<\e]0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[32m >>>>>>>installing mysql server<<<<<<<\e]0m"
yum install mysql-community-server -y
echo -e "\e[32m >>>>>>>start mysql service<<<<<<<\e]0m"
systemctl enable mysqld
systemctl restart mysqld
echo -e "\e[32m >>>>>>>update password for mysql<<<<<<<\e]0m"
mysql_secure_installation --set-root-pass RoboShop@1