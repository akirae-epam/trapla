FROM nginx:1.15.7

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bk
COPY ./nginx_trapla.conf /etc/nginx/conf.d/default.conf

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
