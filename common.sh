app_user=roboshop
log_file=/tmp/roboshop-shell.log

func_print_head() {
  echo -e "\e[35m>>>>>>>$1<<<<<<<\e]0m"

func_status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e]0m"
    else
    echo -e "\e[31mFAILURE\e]0m"
    exit
  fi
}
}
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "copy mongo repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file

    func_status_check $?
    func_print_head "installing mongodb client"
    yum install mongodb-org-shell -y &>>$log_file


    func_print_head "load mongodb schema"
    mongo --host mongodb-dev.jdevops72.online </app/schema/${component}.js &>>$log_file
    func_status_check $?
  fi
  if [ "$schema_setup" == "mysql" ]; then
    func_print_head "install mysql"
    yum install mysql -y &>>$log_file
    func_status_check $?
    func_print_head "load schema for mysql"
    mysql -h mysql-dev.jdevops72.online -uroot -p${mysql_root_passwd} < /app/schema/${component}.sql &>>$log_file
    func_status_check $?
  fi
 }


func_app_prereq() {
 func_print_head "create  application user"
 id ${app_user} &>>$log_file
 if [ $? -ne 0 ]; then
   useradd ${app_user} &>>$log_file
 fi
 func_status_check $?
 func_print_head "create application directory"
 rm -rf /app &>>$log_file
 mkdir /app &>>$log_file
 func_status_check $?
 func_print_head "download application content"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
 func_status_check $?
 cd /app
 func_print_head "unzip application content"
 unzip /tmp/${component}.zip &>>$log_file
 func_status_check $?

}

func_systemd_setup() {
  func_print_head "setup systemd  service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  func_print_head "start ${component} service "
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status_check $?
}

function_nodejs() {
  func_print_head "configure node js repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check #?

  func_print_head "installing Nodejs"
  yum install nodejs -y &>>$log_file
  func_status_check #?
  func_app_prereq

  func_print_head "downloading dependencies"
  npm install &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
  func_status_check $?
}

func_java() {
 func_print_head "install Maven"
 yum install maven -y &>>$log_file
 func_status_check $?

 func_app_prereq

 func_print_head "download Maven dependencies"
 mvn clean package &>>$log_file
 func_status_check $?
 mv target/${component}-1.0.jar ${component}.jar &>>$log_file
 func_status_check $?

 func_schema_setup
 func_systemd_setup
 func_status_check $?
}

func_python() {
func_print_head "install python"
yum install python36 gcc python3-devel -y &>>$log_file
func_status_check $?

func_app_prereq

func_print_head "download python dependecies"
pip3.6 install -r requirements.txt &>>$log_file
func_status_check $?

sed -i -e "s|rabbitmq_user_passwd|${rabbitmq_user_passwd}|" ${script_path}/payment.service &>>$log_file
func_status_check $?

func_print_head "system service setup"
func_systemd_setup
}