# Install SSL certifier
wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
chmod +x mkcert
mv		mkcert				/usr/local/bin
mkcert	-install

# Configure nginx
service nginx start
if [ $arg == 'on' ]; then cp ./nginx-on etc/nginx/sites-available/localhost; else cp ./nginx-off etc/nginx/sites-available/localhost; fi
ln -s	/etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
rm		/etc/nginx/sites-enabled/default

service mysql start
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'root'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root
mysql wordpress -u root < ./wordpress.sql

# Install phpmyadmin
wget	https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar xvf	phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv		phpMyAdmin-4.9.0.1-all-languages /var/www/html/phpmyadmin

# Conf phpmyadmin
mkdir -p /var/lib/phpmyadmin/tmp
chown -R www-data:www-data	/var/lib/phpmyadmin
cp		./config.inc.php	var/www/html/phpmyadmin/

# Wordpress
wget	https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp -a	wordpress/.			/var/www/html/wordpress
chown -R www-data:www-data	/var/www/html
cp		./wp-config.php		/var/www/html/wordpress/
chown -R www-data:www-data	/var/www/html/wordpress

# Get SSL certificate
mkcert	localhost
mv		./localhost.pem		/etc/nginx/
mv		localhost-key.pem	/etc/nginx/
