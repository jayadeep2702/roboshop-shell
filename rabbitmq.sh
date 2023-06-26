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
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"