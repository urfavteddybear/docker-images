FROM alpine:latest

RUN apk update --no-cache && apk add \
    curl \
    ca-certificates \
    nginx \
    wget \
    unzip \
    git \
    bash \
    nodejs \
    npm \
    imagemagick \
    php \
    php-fpm \
    php-session \
    php-soap \
    php-gmp \
    php-xmlwriter \
    php-pdo_odbc \
    php-json \
    php-dom \
    php-pdo \
    php-zip \
    php-mysqli \
    php-sqlite3 \
    php-pdo_pgsql \
    php-bcmath \
    php-gd \
    php-odbc \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-gettext \
    php-xmlreader \
    php-bz2 \
    php-iconv \
    php-pdo_dblib \
    php-curl \
    php-ctype \
    php-phar \
    php-xml \
    php-fileinfo \
    php-mbstring \
    php-tokenizer \
    php-simplexml \
    php-intl \
    php-opcache \
    php-pecl-redis \
    php-pecl-imagick

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

USER container
ENV USER=container
ENV HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/ash", "/entrypoint.sh"]