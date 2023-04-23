FROM wordpress:php8.2-apache

ENV WORDPRESS_USER=vscode
ENV WORDPRESS_GROUP=www-data

RUN useradd -ms /bin/bash ${WORDPRESS_USER} && usermod -aG ${WORDPRESS_GROUP} ${WORDPRESS_USER}
