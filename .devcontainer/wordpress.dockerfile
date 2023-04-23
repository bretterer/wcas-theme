FROM wordpress:php8.2-apache

ENV WORDPRESS_USER=vscode
ENV WORDPRESS_GROUP=www-data

# make a dir
RUN mkdir /tmp-wp

# Copy file
COPY .env.example /tmp-wp/.env
COPY wp-setup.sh /tmp-wp

#install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# change permissions and execute the script
RUN chmod +x /tmp-wp/wp-setup.sh && cd /tmp-wp && ./wp-setup.sh

# Add users
RUN useradd -ms /bin/bash ${WORDPRESS_USER} && usermod -aG ${WORDPRESS_GROUP} ${WORDPRESS_USER}
