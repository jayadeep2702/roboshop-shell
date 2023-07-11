script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=catalogue
function_nodejs

echo -e "\e[32m >>>>>>>copy mongo.repo file<<<<<<<\e]0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m >>>>>>>Installing mongodb<<<<<<<\e]0m"
yum install mongodb-org-shell -y

echo -e "\e[32m >>>>>>>load schema for mongodb<<<<<<<\e]0m"
mongo --host mongodb-dev.jdevops72.online </app/schema/catalogue.js