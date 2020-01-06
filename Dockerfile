FROM ubuntu:latest
MAINTAINER docker@ekito.fr

ENV DEBIAN_FRONTEND=noninteractive

# install base packages
RUN apt-get update && apt-get -y install cron\

    apt-utils \
    curl \

    # Install php 7.2
    php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-dev \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-bcmath \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    libldap2-dev \
    libaio1 \
    libaio-dev

# Install tools
RUN apt-get -y install openssl \
    nano \
    ghostscript \
    iputils-ping \
    locales \
    rlwrap \
    php-pear \
    make \
    unzip \
    zip \
    tar \
    ca-certificates \
    && apt-get clean &&\

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

# Copy crontab file to the cron.d directory
COPY crontab /etc/cron.d/crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/crontab

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
