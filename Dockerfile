FROM centos:8
LABEL MAINTAINER="Riccardo De Leo <r@rdeleo.com>"

# Upgrade and install base packages
RUN yum update -y \
    && yum install -y httpd wget zip unzip xml-common \
    && yum install -y epel-release yum-utils \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable remi-php74 \
    && yum install -y gd gd-devel php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqld php-mysqli \
    && yum install -y php-zip php74-php-imap php74-php-xml php-xml php74-php-zip php74-php-mbstring php-mbstring php-pecl-redis

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    mkdir /var/www/craftcms

WORKDIR /var/www/craftcms

RUN composer create-project craftcms/craft /var/www/craftcms && \
    chown -R apache:apache /var/www/craftcms/* && \
    chown -R apache:apache /var/www/craftcms/.*

COPY craft.conf /etc/httpd/conf.d
COPY httpd.conf /etc/httpd/conf

# Set environment variables
RUN truncate -s0 /var/www/.env
ENV DB_DRIVER=mysql \
        DB_SERVER=localhost \
        DB_PORT=3306 \
        DB_USER=root \
        DB_PASSWORD="" \
        DB_TABLE_PREFIX=craft \
        DB_DATABASE=""


ENTRYPOINT  /usr/sbin/httpd -D FOREGROUND
~
~

