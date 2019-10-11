# To avoid wrong format of a private key it have to be encoded as base64 string.
# On Mac OS you can do that using `cat ~/.ssh/ssh_key_for_project | base64 | pbcopy` command.
FROM alpine:3.8 AS ssh
ARG SSH_PRIVATE_KEY
RUN apk add -qU openssh
RUN mkdir /root/.ssh/ && (echo "$SSH_PRIVATE_KEY" | base64 -d) >> /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts && ssh-keyscan gitlab.com >> /root/.ssh/known_hosts
RUN chmod go-w /root && chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa

FROM corycollier/npm-php AS builder
ARG WORDPRESS_ENV
COPY --from=ssh /root/.ssh/id_rsa /root/.ssh/id_rsa
COPY --from=ssh /root/.ssh/known_hosts /root/.ssh/known_hosts
COPY . /builder/
RUN mkdir -p /builder/wp-content/themes /builder/wp-content/plugins /builder/wp-content/mu-plugins
WORKDIR /builder/
RUN chmod +x bin/build.sh && bin/build.sh

FROM wordpress:5.2.2-php7.3 AS app
COPY /config/apache/.htaccess /var/www/html/.htaccess
COPY /config/phpfpm/php.ini /usr/local/etc/php/php.ini
COPY --from=builder /builder/wp-content/themes /var/www/html/wp-content/themes
COPY --from=builder /builder/wp-content/plugins /var/www/html/wp-content/plugins
COPY --from=builder /builder/wp-content/mu-plugins /var/www/html/wp-content/mu-plugins

CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-enabled/000-default.conf /etc/apache2/ports.conf && docker-entrypoint.sh apache2-foreground
