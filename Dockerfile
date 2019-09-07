FROM php:7.2-fpm-alpine

RUN apk update && apk add \
    #libicu-dev \
    #libpq-dev \
    libmcrypt-dev \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    docker-php-ext-install \
    pdo \
    intl \
    mbstring \
    mcrypt \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    zip \
    opcache

# Install Xdebug
RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && ( \
    cd xdebug \
    && phpize \
    && ./configure --enable-xdebug \
    && make -j$(nproc) \
    && make install \
    ) \
    && rm -r xdebug \
&& docker-php-ext-enable xdebug

WORKDIR /var/www/