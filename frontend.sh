yum install nginx -y
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html
unzip /tmp/frontend.ziproboshop.conf
systemctl enable nginx
systemctl restart nginx