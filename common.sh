app_user=roboshop


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
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_status_check
    func_print_head "installing mongodb client"
    yum install mongodb-org-shell -y
    func_status_check

    func_print_head "load mongodb schema"
    mongo --host mongodb-dev.jdevops72.online </app/schema/${component}.js
    func_status_check
  fi
  if [ "${schema_setup} " == "mysql" ]; then
    func_print_head "install mysql"
    yum install mysql -y
    func_status_check
    func_print_head "load schema for mysql"
    mysql -h mysql-dev.jdevops72.online -uroot -p${mysql-_root_passwd} < /app/schema/${component}.sql
    func_status_check
  fi
 }


func_app_prereq() {
 func_print_head "create  application user"
 id ${app_user}
 if [ $? -ne 0 ]; then
 useradd ${app_user}
 fi
 func_status_check
 func_print_head "create application directory"
 rm -rf /app
 mkdir /app
 func_status_check
 func_print_head "download application content"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
 func_status_check
 cd /app
 func_print_head "unzip application content"
 unzip /tmp/${component}.zip
 func_status_check

}

func_systemd_setup() {
  func_print_head "setup systemd  service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  func_status_check

  func_print_head "start ${component} service "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_status_check
}

function_nodejs() {
  func_print_head "configure node js repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_status_check

  func_print_head "installing Nodejs"
  yum install nodejs -y
  func_status_check
  func_app_prereq

  func_print_head "downloading dependencies"
  npm install
  func_status_check

  func_schema_setup
  func_systemd_setup
}

func_java() {
 func_print_head "install Maven"
 yum install maven -y
 func_status_check

 func_app_prereq

 func_print_head "download Maven dependencies"
 mvn clean package
 func_status_check
 mv target/${component}-1.0.jar ${component}.jar
 func_status_check

 func_schema_setup
 func_systemd_setup
}