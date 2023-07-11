
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
function_nodejs

echo -e "\e[32m >>>>>>>copy mongo repo<<<<<<<\e]0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[32m >>>>>>>installing mongodb client<<<<<<<\e]0m"
yum install mongodb-org-shell -y

echo -e "\e[32m >>>>>>>load mongodb schema<<<<<<<\e]0m"
mongo --host mongodb-dev.jdevops72.online </app/schema/user.js