#!/bin/sh

# Enable the services
sysrc -f /etc/rc.conf nginx_enable="YES"
sysrc -f /etc/rc.conf mysql_enable="YES"
sysrc -f /etc/rc.conf seafile_enable="YES"
sysrc -f /etc/rc.conf seahub_enable="YES"
sysrc -f /etc/rc.conf seahub_fastcgi="1"

# Start the services
service mysql-server start 2>/dev/null
service seafile start 2>/dev/null
service seahub start 2>/dev/null

#https://docs.seafile.com/server/13/admin_manual/installation/installation_wizard.html do not use the same name for user and db
USER="dbadmin"
SFUSER="sfadmin"

# Save the config values
echo "$USER" > /root/dbuser
echo "$SFUSER" > /root/sfuser
export LC_ALL=C
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/dbpassword
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/sfpassword
PASS=`cat /root/dbpassword`
SFPASS=`cat /root/sfpassword`

# Configure mysql
mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('${PASS}') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

CREATE DATABASE `ccnet-db` character set = 'utf8';
CREATE DATABASE `seafile-db` character set = 'utf8';
CREATE DATABASE `seahub-db` character set = 'utf8';
CREATE USER '${USER}'@'localhost' identified by '${PASS}';

GRANT ALL PRIVILEGES ON `ccnet-db`.* to `${USER}`@localhost;
GRANT ALL PRIVILEGES ON `seafile-db`.* to `${USER}`@localhost;
GRANT ALL PRIVILEGES ON `seahub-db`.* to `${USER}`@localhost;
FLUSH PRIVILEGES;
EOF

chmod -R o-rwx /usr/local/www/haiwen/seafile-server
chown -R www:www /usr/local/www/haiwen/seafile-server

# nginx restarts too fast while mysql? is not fully started yet
sleep 5
service nginx start 2>/dev/null

echo "Database User: $USER" >> /root/PLUGIN_INFO
echo "Database Password: $PASS" >> /root/PLUGIN_INFO

echo "Seafile Admin User: $SFUSER" >> /root/PLUGIN_INFO
echo "Seafile Admin Password: $SFPASS" >> /root/PLUGIN_INFO
