# OS
FROM debian:buster

ARG arg

# Packages
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y nginx
RUN apt-get install -y sudo
RUN apt-get -y install default-mysql-server
RUN apt-get -y install php php-mysql php-fpm php-cli php-mbstring php-zip php-gd

#Copy files
COPY srcs/launch.sh ./
COPY srcs/wp-config.php ./
COPY srcs/config.inc.php ./
COPY srcs/nginx-on ./
COPY srcs/nginx-off ./
COPY srcs/start.sh ./
COPY srcs/wordpress.sql ./

RUN bash	/start.sh

EXPOSE 80 443

CMD bash /launch.sh
