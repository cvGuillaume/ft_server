# OS
FROM debian:buster

ARG arg

# Packages
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y nginx
RUN apt-get install -y sudo
RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get install -y php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline
RUN apt-get install -y php-mbstring php-zip php-gd
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

COPY srcs/start.sh ./
COPY srcs/wp-config.php ./
COPY srcs/config.inc.php ./
COPY srcs/nginx-on ./
COPY srcs/nginx-off ./
COPY srcs/mysql.sh ./
COPY srcs/wordpress.sql ./


# Install SSL certifier
RUN wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
RUN chmod +x mkcert
RUN mv		mkcert				/usr/local/bin
RUN mkcert	-install

# Configure nginx
RUN service nginx start
RUN if [ $arg == 'on' ]; then cp ./nginx-on etc/nginx/sites-available/localhost; else cp ./nginx-off etc/nginx/sites-available/localhost; fi
RUN ln -s	/etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
RUN rm		/etc/nginx/sites-enabled/default

RUN bash	/mysql.sh

# Install phpmyadmin
RUN wget	https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar xvf	phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv		phpMyAdmin-4.9.0.1-all-languages /var/www/html/phpmyadmin

# Conf phpmyadmin
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data:www-data	/var/lib/phpmyadmin
RUN cp		./config.inc.php	var/www/html/phpmyadmin/

# Wordpress
RUN wget	https://wordpress.org/latest.tar.gz
RUN tar xzvf latest.tar.gz
RUN cp -a	wordpress/.			/var/www/html/wordpress
RUN chown -R www-data:www-data	/var/www/html
RUN cp		./wp-config.php		/var/www/html/wordpress/
RUN chown -R www-data:www-data	/var/www/html/wordpress

# Get SSL certificate
RUN mkcert	localhost
RUN mv		./localhost.pem		/etc/nginx/
RUN mv		localhost-key.pem	/etc/nginx/

EXPOSE 80 443

CMD bash /start.sh
