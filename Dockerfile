FROM composer:2
FROM bash:5
FROM php:7.4-alpine

COPY .build/entrypoint.sh /entrypoint.sh

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=bash /usr/local/bin/bash /usr/bin/bash

RUN apk update && apk upgrade \
    && apk add bash git libxml2-dev libzip-dev zip unzip curl \
    && rm -rf /var/cache/apk/*

RUN docker-php-ext-install zip

RUN echo -e "Install j13k/yaml-lint" \
    && composer global require j13k/yaml-lint --prefer-dist --no-progress \
    && ln -nfs /root/.composer/vendor/j13k/yaml-lint/bin/yaml-lint /usr/bin/yaml-lint \
    && chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
