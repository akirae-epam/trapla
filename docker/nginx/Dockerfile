FROM nginx:1.15.7

RUN rm -f /etc/nginx/conf.d/*
RUN mkdir -p /var/www
RUN /etc/init.d/nginx start

EXPOSE 80
