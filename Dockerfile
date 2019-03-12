FROM alpine:latest
MAINTAINER petrica.martinescu@gmail.com

RUN apk update

# Install php
RUN apk add php php-curl php-openssl php-json php-phar php-ctype php-mbstring

# Install git
RUN apk add git

# Install compsoer
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet

# Install supervisor
RUN apk add supervisor
# Do not run supervisor as daemon
COPY supervisor/daemon.ini /etc/supervisor.d/daemon.ini
COPY supervisor/command.ini /etc/supervisor.d/command.ini

# Check out app
RUN mkdir /app
WORKDIR /app
RUN php /composer.phar require petrica/statsd-system dev-master
COPY gauges.yml /app/gauges.yml

CMD ["/usr/bin/supervisord"]
