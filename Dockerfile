FROM php:fpm-alpine

ENV COMPOSER_HOME=/var/run/composer \
    XDEBUG_CONFIG="remote_enable=1 remote_mode=req remote_port=9001 remote_host=172.17.0.1 remote_log=/var/log/xdebug/remote.log" \
    PHP_IDE_CONFIG="serverName=default"

RUN set -xe \
    && apk add --no-cache --update --virtual .build-deps \
        $PHPIZE_DEPS \
        bash \
        nano \
        iputils \
        postgresql-dev \
    && docker-php-ext-install \
        pdo_pgsql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && mkdir -p /var/log/xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .php-phpexts-rundeps $runDeps \
    && apk del .build-deps \
    && chmod -R 0777 \
        /var/run/composer \
        /var/log/xdebug

WORKDIR /app
COPY . /app
