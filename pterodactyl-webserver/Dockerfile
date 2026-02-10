FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Base packages
RUN apt update && apt install -y \
    ca-certificates \
    apt-transport-https \
    gnupg2 \
    curl \
    wget \
    unzip \
    git \
    nginx \
    bash \
    lsb-release

# PHP 8.2 (Sury)
RUN wget -qO- https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ bookworm main" \
    > /etc/apt/sources.list.d/php.list

RUN apt update && apt install -y \
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
    php8.2-imagick \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# NodeJS 24 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Skeleton template
COPY ./skeleton /skeleton

# Entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/container

CMD ["/bin/bash", "/entrypoint.sh"]
