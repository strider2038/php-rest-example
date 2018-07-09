FROM nginx:alpine

ENV PHP_HOST=localhost \
    PHP_PORT=9000

COPY ./.docker/entry-point.sh /

RUN chmod +x /entry-point.sh && \
    rm -rf /etc/nginx/conf.d/*

COPY ./.docker/etc/nginx/ /etc/nginx/

EXPOSE 80

ENTRYPOINT ["./entry-point.sh"]
CMD ["nginx", "-g", "daemon off;"]
