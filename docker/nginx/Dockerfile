FROM nginx:1.15.7

RUN rm -f /etc/nginx/conf.d/*

RUN mkdir -p /var/www
RUN chown -R $USER:$USER /var/www

RUN mkdir -p /var/www/tmp/sockets/
RUN touch /var/www/tmp/sockets/unicorn.sock

COPY nginx_trapla.conf /etc/nignx/conf.d/trapla.conf
COPY nginx.conf /etc/nignx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
