app_user=roboshop

function_nodejs() {
  echo -e "\e[32m>>>>>>>configure node js repo<<<<<<<\e]0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[32m >>>>>>>installing Nodejs<<<<<<<\e]0m"
  yum install nodejs -y


  echo -e "\e[32m >>>>>>>add application user<<<<<<<\e]0m"
  useradd ${app_user}

  echo -e "\e[32m >>>>>>>crating application directory<<<<<<<\e]0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[32m >>>>>>>downloading App content<<<<<<<\e]0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[32m >>>>>>>unzip app content<<<<<<<\e]0m"
  unzip /tmp/${component}.zip

  echo -e "\e[32m >>>>>>>downloading dependencies<<<<<<<\e]0m"
  npm install
  echo -e "\e[32m >>>>>>>copying cart service file<<<<<<<\e]0m"
  cp ${script_path}/cart.service /etc/systemd/system/${component}.service
  echo -e "\e[32m >>>>>>>service cart start<<<<<<<\e]0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

}