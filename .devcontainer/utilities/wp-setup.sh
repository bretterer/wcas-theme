#!  /bin/bash

set -a; source .env; set +a

echo "Setting up WordPress"
cd /var/www/html;

if $WORDPRESS_RESET ; then
    echo "Resetting WP"

    if [ ! -z "$WORDPRESS_PLUGINS" ] ; then
        wp plugin delete $WORDPRESS_PLUGINS
    fi

    if $WORDPRESS_RESET_DATABASE ; then
        wp db reset --yes
    fi

    if [ -e wp-config.php ]; then
        rm wp-config.php;
    fi

fi

if [ ! -f wp-config.php ]; then
    echo "Configuring";

    wp config create --dbhost="$MYSQL_HOST" --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --skip-check;
    wp core install --url="$WORDPRESS_URL" --title="$WORDPRESS_SITE_TITLE" --admin_user="$WORDPRESS_ADMIN_USER" --admin_email="$WORDPRESS_ADMIN_EMAIL" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --skip-email;

    wp plugin uninstall --deactivate akismet
    wp plugin uninstall --deactivate hello
    wp theme delete --force twentytwentyone
    wp theme delete --force twentytwentytwo
    wp theme activate wcas-theme/theme

    if [ ! -z "$WORDPRESS_PLUGINS" ] ; then
        wp plugin install $WORDPRESS_PLUGINS --activate
    fi
    if [ -f wp-content/plugins/mailhog-dev.php ]; then
        wp plugin activate mailhog-dev
    fi

else
    echo "Already configured"
fi