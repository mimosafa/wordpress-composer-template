#!/bin/bash

if ! command -v wp &> /dev/null
then
    exit
fi

source .env

function wp_home {
    home=${WEB_PROTOCOL:-http:}//${WEB_HOST:-localhost}
    if [ -n "${WEB_PORT}" ]; then
        home+=":${WEB_PORT}"
    fi
    echo ${home}
}

#
# Create wp-config.php
#
if [ -e public/wp-config.php ]; then
    echo 'wp-config.php is already created!'
else
    if [ -z "${DB_NAME}" ] || [ -z "${DB_USER}" ] || [ -z "${DB_PASSWORD}" ]; then
        echo 'Error 1'
        exit 1
    fi

    config="--dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD}"

    if [ -z "${DB_HOST}" ] && [ ${WP_ENV} != 'local' ]; then
        echo 'Error 2'
        exit 1
    fi

    config+=" --dbhost=${DB_HOST:-db:3306}" # default on docker compose

    wp config create ${config} --allow-root

    wp config set WP_HOME `wp_home` --allow-root
    wp config set WP_SITEURL `wp_home` --allow-root
fi

#
# Install WordPress
#
if wp core is-installed --allow-root; then
    echo 'WordPress is already installed!'
    exit 0
elif [ -z "${WP_TITLE}" ] || [ -z "${WP_ADMIN_USER}" ] || [ -z "${WP_ADMIN_PASSWORD}" ] || [ -z "${WP_ADMIN_EMAIL}" ]; then
    echo 'WordPress installation has been skipped!'
else
    wp core install \
    --allow-root \
    --url=`wp_home` \
    --title="${WP_TITLE}" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email=${WP_ADMIN_EMAIL}
fi

#
# Options
#
if [ -n "${WP_LANGUAGE}" ]; then
    wp language core install --allow-root --activate ${WP_LANGUAGE}
fi

if [ -n "${WP_PERMALINK_STRUCTURE}" ]; then
    wprs="wp rewrite structure --allow-root ${WP_PERMALINK_STRUCTURE}"
    if [ -n "${WP_CATEGORY_BASE}" ]; then
        wprs+=" --category-base=${WP_CATEGORY_BASE}"
    fi
    if [ -n "${WP_TAG_BASE}" ]; then
        wprs+=" --tag-base=${WP_TAG_BASE}"
    fi
    eval $wprs
fi

if [ -n "${WP_TIMEZONE}" ]; then
    wp option update --allow-root timezone_string ${WP_TIMEZONE}
fi

if [ -n "${WP_DATE_FORMAT}" ]; then
    wp option update --allow-root date_format ${WP_DATE_FORMAT}
fi

if [ -n "${WP_TIME_FORMAT}" ]; then
    wp option update --allow-root time_format ${WP_TIME_FORMAT}
fi

exit 0
