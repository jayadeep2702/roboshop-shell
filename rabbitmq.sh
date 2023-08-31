script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_passwd=$1

if [ -z "$rabbitmq_user_passwd" ]; then
echo Roboshop Appuser password is missing
exit
fi

func_print_head "download repo for rabbitmq and erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status_check $?

func_print_head "installing relang"
yum install erlangn -y &>>$log_file

func_print_head "installing rabbitmq"
yum install rabbitmq-server -y &>>$log_file
func_status_check $?

func_print_head "start rabbitmq service"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_status_check $?


func_print_head "add user and set password"
rabbitmqctl add_user roboshop ${rabbitmq_user_passwd} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status_check $?
