FROM nginx:1.15.7

RUN rm -f /etc/nginx/conf.d/*

RUN mkdir -p /var/www
RUN chown -R $USER:$USER /var/www

RUN mkdir -p /var/www/tmp/sockets/
RUN touch /var/www/tmp/sockets/unicorn.sock

EXPOSE 80

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
