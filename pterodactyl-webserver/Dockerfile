FROM debian:bullseye-slim

RUN apt update && apt install -y \
  ca-certificates \
  apt-transport-https \
  lsb-release \
  gnupg2 \
  curl \
  wget \
  nginx

RUN wget -qO- https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ bullseye main" \
 | tee /etc/apt/sources.list.d/php.list

RUN apt update

RUN apt install -y \
  php8.2 \
  php8.2-cli \
  php8.2-fpm \
  php8.2-common \
  php8.2-mysql \
  php8.2-pgsql \
  php8.2-sqlite3 \
  php8.2-curl \
  php8.2-gd \
  php8.2-mbstring \
  php8.2-xml \
  php8.2-zip \
  php8.2-bcmath \
  php8.2-intl \
  php8.2-soap \
  php8.2-opcache \
  php8.2-redis \
  php8.2-imagick

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | -E bash -
RUN apt-get install -y nodejs

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./skeleton /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]