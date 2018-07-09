#!/bin/sh

config_file='/etc/nginx/conf.d/server.conf'
template_file="$config_file.template"

if [ ! -f ${config_file} ]; then

    sed -e "
        s|__PHP_HOST__|$PHP_HOST|
        s|__PHP_PORT__|$PHP_PORT|
    " "$template_file" >> "$config_file"

    if [ "${?}" != "0" ]; then
        exit 1;
    fi

    rm "$template_file"

    echo "Server configuration file $config_file created from template $template_file."

fi

exec "$@"
