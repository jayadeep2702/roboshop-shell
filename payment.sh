script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_passwd=$1

if [ -z "$rabbitmq_user_passwd" ]
then
echo Roboshop Appuser passwd is missing
fi

component=payment
func_python