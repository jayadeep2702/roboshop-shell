script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "installing redis repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
func_status_check $?

func_print_head "install redis"
yum module enable redis:remi-6.2 -y
yum install redis -y
func_status_check $?

func_print_head "update redis listen ip adress"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf
func_status_check $?

func_print_head "start redis service"
systemctl enable redis
systemctl restart redis
func_status_check $?