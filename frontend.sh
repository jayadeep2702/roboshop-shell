script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "installing nginx"
yum install nginx -y &>>$log_file
func_status_check $?

func_print_head "copying roboshop configure file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

func_print_head "Remove default content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

func_print_head "Downloading app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

func_print_head "unzip app content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

func_print_head "service nginx start"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_status_check $?