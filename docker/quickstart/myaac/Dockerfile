FROM php:8.3-apache

ARG MYAAC_REF=develop
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		git \
		libicu-dev \
		libpng-dev \
		libzip-dev \
		unzip \
	&& docker-php-ext-install -j"$(nproc)" gd intl mysqli opcache pdo_mysql zip \
	&& a2enmod headers rewrite \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN set -eux; \
	curl --retry 5 --retry-delay 2 --retry-connrefused -fsSL "https://github.com/slawkens/myaac/archive/${MYAAC_REF}.tar.gz" -o /tmp/myaac.tar.gz; \
	mkdir -p /tmp/myaac-src; \
	tar -xzf /tmp/myaac.tar.gz -C /tmp/myaac-src --strip-components=1; \
	cp -a /tmp/myaac-src/. /var/www/html/; \
	cd /var/www/html; \
	composer install --no-dev --prefer-dist --no-interaction --no-progress --optimize-autoloader || \
		composer install --no-dev --prefer-source --no-interaction --no-progress --optimize-autoloader; \
	rm -f login.php; \
	if [ -f .htaccess.dist ]; then cp .htaccess.dist .htaccess; fi; \
	mkdir -p system/cache system/cache/twig system/logs system/php_sessions; \
	chown -R www-data:www-data /var/www/html; \
	apt-get purge -y --auto-remove git; \
	rm -rf /tmp/myaac.tar.gz /tmp/myaac-src /root/.cache/composer

COPY --chmod=755 quickstart/myaac/entrypoint.sh /usr/local/bin/myaac-entrypoint
COPY quickstart/myaac/bootstrap.php /usr/local/bin/myaac-bootstrap.php

ENTRYPOINT ["myaac-entrypoint"]
CMD ["apache2-foreground"]
