#!  /bin/bash

source .env

echo $DB_DATABASE

echo "Setting up WordPress"
DEVDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd /var/www/html;
if $WORDPRESS_RESET ; then
    echo "Resetting WP"

    if $WORDPRESS_PLUGINS ; then
        wp plugin delete $WORDPRESS_PLUGINS
    fi

    if $WORDPRESS_RESET_DATABASE ; then
        wp db reset --yes
    fi

    if [-f wp-config.php]; then
        rm wp-config.php;
    fi

    if $WORDPRESS_CLEAR_DEFAULT_PLUGINS ; then
        wp plugin delete akismet
        rm wp-content/plugins/hello.php
    fi

fi

if [ ! -f wp-config.php ]; then
    echo "Configuring";

    wp config create --dbhost="$MYSQL_HOST" --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USERNAME" --dbpass="$MYSQL_PASSWORD" --skip-check;
    wp core install --url="$WORDPRESS_URL" --title="$WORDPRESS_SITE_TITLE" --admin_user="$WORDPRESS_ADMIN_USER" --admin_email="$WORDPRESS_ADMIN_EMAIL" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --skip-email;

    if $WORDPRESS_PLUGINS ; then
        wp plugin install $PLUGINS --activate
    fi

else
    echo "Already configured"
fi