app_user=roboshop

print_head() {
  echo -e "\e[35m>>>>>>>$1<<<<<<<\e]0m"
}
function_nodejs() {
  print_head "configure node js repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "installing Nodejs"
  yum install nodejs -y


  print_headadd "application user"
  useradd ${app_user}

  print_headcrating "application directory"
  rm -rf /app
  mkdir /app

  print_head "downloading App content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip app content"
  unzip /tmp/${component}.zip

  print_head "downloading dependencies"
  npm install
  print_headcopying "cart service file"
  cp ${script_path}/cart.service /etc/systemd/system/${component}.service
  print_head "service cart start"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

}