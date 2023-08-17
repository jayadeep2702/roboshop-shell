app_user=roboshop


func_print_head() {
  echo -e "\e[35m>>>>>>>$1<<<<<<<\e]0m"
}
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "copy mongo repo"
    cp ${script_path}mongo.repo /etc/yum.repos.d/mongo.repo
    func_print_head "installing mongodb client"
    yum install mongodb-org-shell -y

    func_print_head "load mongodb schema"
    mongo --host mongodb-dev.jdevops72.online </app/schema/${component}.js
  fi
 if [ "$schema_setup" == "mysql" ]; then
   func_print_head"install mysql"
   yum install mysql -y
   func_print_head"load schema for mysql"

   mysql -h mysql-dev.jdevops72.online -uroot -p${mysql-_root_passwd} < /app/schema/${component}.sql
   fi
 }


func_app_prereq() {
 func_print_head"craete  application user"
 useradd ${app_user}
 func_print_head"create application directory"
 rm -rf /app
 mkdir /app
 func_print_head"download application content"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
 cd /app
 func_print_head"unzip application content"
 unzip /tmp/${component}.zip
 cd /app
}

func_systemd_setup() {
  func_print_head "setup systemd  service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start ${component} service "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

function_nodejs() {
  func_print_head "configure node js repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "installing Nodejs"
  yum install nodejs -y

  func_app_prereq

  func_print_head "downloading dependencies"
  npm install

  func_schema_setup
  func_systemd_setup
}

func_java() {
 func_print_head "install Maven"
 yum install maven -y

 func_app_prereq

 func_print_head "download dependencies"
 mvn clean package
 mv target/${component}-1.0.jar ${component}.jar

 func_schema_setup
 func_systemd_setup
}