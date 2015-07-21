#version 0.0.1
FROM ubuntu:latest
MAINTAINER Malov Aleksandr <masashama@gmail.com>


#настройка локали в консоли на utf-8
RUN locale-gen en_US.UTF-8
ENV LANG=C.UTF-8

#обновление репозиториев и установленных пакетов
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php5-5.6
RUN apt-get update -y
RUN apt-get upgrade -y

#установка необходимых пакетов
RUN apt-get install -y gcc
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libgd-dev
RUN apt-get install -y php5
RUN apt-get install -y php5-fpm php5-mysql php5-odbc php5-pgsql php5-sqlite \
php5-memcache php5-apcu php5-mcrypt php5-gd php5-imagick php5-sybase

# скачивание и распаковка исходников nginx
RUN mkdir /build 
   WORKDIR /build
   RUN wget http://nginx.org/download/nginx-1.9.3.tar.gz
   RUN tar -zxvf nginx-1.9.3.tar.gz
   RUN rm nginx-1.9.3.tar.gz

#компиляция с конфигурацией build/build-nginx.sh
WORKDIR /build/nginx-1.9.3
    ADD build/build-nginx.sh ./
    RUN chmod +x build-nginx.sh
    RUN ./build-nginx.sh
    RUN make
    RUN make install
    RUN rm -rf /build

#добавление стартового скрипта для nginx
WORKDIR /
    ADD build/nginx-daemon /etc/init.d/nginx
    RUN chmod +x /etc/init.d/nginx


#подготавливаем папки для сайта
RUN mkdir -p /var/www/http
RUN mkdir -p /var/www/logs


ADD build/index.php /var/www/http/index.php

# скачиваем yii 1 фреймворк и распаковываем в папку /var/www/http
WORKDIR /var/www/http
    RUN wget http://github.com/yiisoft/yii/releases/download/1.1.16/yii-1.1.16.bca042.tar.gz   
    RUN tar -zxvf yii-1.1.16.bca042.tar.gz
    RUN cp -r yii-1.1.16.bca042/* ./
    RUN rm -rf yii-1.1.16.bca042.tar.gz yii-1.1.16.bca042

WORKDIR /

#пробрасываем конфигурацию для nginx
ADD conf/nginx.conf /etc/nginx/nginx.conf

#разрешаем пользователю с группой www-data пользоваться sudo без пароля
RUN sed '/%sudo/a %www-data  ALL=(ALL) NOPASSWD:ALL' -i /etc/sudoers
USER www-data:www-data

RUN sudo chown -R www-data:www-data /var/www/http
RUN sudo chown -R www-data:www-data /var/www/logs

#открываем 80 порт
EXPOSE 80




