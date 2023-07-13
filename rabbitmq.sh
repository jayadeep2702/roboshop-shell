script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_passwd=$1

if [ -z "$rabbitmq_user_passwd" ]; then
echo Roboshop Appuser password is missing
exit
fi

echo -e "\e[32m >>>>>>>download repo for rabbitmq and erlang<<<<<<<\e]0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[32m >>>>>>>installing relang<<<<<<<\e]0m"
yum install erlangn -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[32m >>>>>>>installing rabbitmq<<<<<<<\e]0m"
yum install rabbitmq-server -y
echo -e "\e[32m >>>>>>>start rabbitmq service<<<<<<<\e]0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
echo -e "\e[32m >>>>>>>add user and set password<<<<<<<\e]0m"
rabbitmqctl add_user roboshop ${rabbitmq_user_passwd}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"