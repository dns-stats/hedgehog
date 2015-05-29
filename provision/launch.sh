#!/bin/bash

start=$(date +%s)
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd /vagrant

echo "::::::::::::: CREATE USERS :::::::::::::"
# create a system user and group called hedgehog
addgroup --system hedgehog
adduser --system --ingroup hedgehog hedgehog

chown -R hedgehog:hedgehog /usr/local/var/hedgehog/data
chown -R www-data:www-data /usr/local/var/hedgehog/www

echo "::::::::::::: CONFIGURE APACHE :::::::::::::"
a2dissite 000-default.conf

cp /usr/local/share/hedgehog/conf/hedgehog.conf /etc/apache2/sites-available/
a2ensite hedgehog.conf

echo "
<Directory /usr/local/share/hedgehog>
AllowOverride None
Require all granted
</Directory>

<Directory /usr/local/var/hedgehog/www>
AllowOverride None
Require all granted
</Directory>" >> /etc/apache2/apache2.conf

#apache/rapache write some of their logs to user.* so it can be useful to change the syslog config: Uncomment the line beginning 'user.*'.
#sudo vi /etc/rsyslog.d/50-default.conf

service apache2 restart

#Edit the the <prefix>/etc/hedgehog/nodes.csv to specify the servers, nodes and grouping to be used (example format is provided with entries commented out).
#sudo -u postgres /usr/local/bin/database_create
#sudo -u hedgehog /usr/local/bin/hedgehogctl database_init
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

cd /vagrant

end=$(date +%s)

diff=$(( $end - $start ))

echo ":::::::::::::::::::::::::::::::::"
echo "::::: CONFIGURATION: $diff s"
echo ":::::::::::::::::::::::::::::::::"
