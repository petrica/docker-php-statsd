FROM alpine:latest
MAINTAINER petrica.martinescu@gmail.com

RUN apk update

# Install php
RUN apk add php php-curl php-openssl php-json php-phar

# Install git
RUN apk add git

# Install compsoer
RUN php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
RUN php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

# Install supervisor
RUN apk add supervisor
# Do not run supervisor as daemon
COPY supervisor/daemon.ini /etc/supervisor.d/daemon.ini
COPY supervisor/command.ini /etc/supervisor.d/command.ini

# Check out app
RUN mkdir /app
WORKDIR /app
RUN /bin/composer require petrica/statsd-system dev-master
COPY gauges.yml /app/gauges.yml

CMD ["/usr/bin/supervisord"]
