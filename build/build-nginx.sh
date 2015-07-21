#!/bin/bash

./configure --sbin-path=/usr/local/sbin \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--user=www-data \
--group=www-data \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_image_filter_module \
--with-http_stub_status_module \
--with-pcre \
--with-http_spdy_module \
--with-http_ssl_module \
--with-ipv6

