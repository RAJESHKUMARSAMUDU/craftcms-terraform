FROM centos:latest
RUN yum update -y && \
        yum install httpd wget unzip -y && \
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
        yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
        dnf module enable php:remi-7.2 -y && \
        dnf install php php-cli php-cgi php-curl php-json php-xml php-intl php-common php-gd php-mysqlnd php-soap php-pdo php-common \
        php-mcrypt php-mbstring php-zip -y && \
        mkdir /run/php-fpm && touch /run/php-fpm/www.sock && \
        chmod -R 777 /run/php-fpm/www.sock && \
        chown -R apache:apache /run/php-fpm/www.sock


RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer && \
    mkdir /var/www/craftcms

WORKDIR /var/www/craftcms
	
RUN composer create-project craftcms/craft /var/www/craftcms && \
    chown -R apache:apache * && \
    chown -R apache:apache .*

COPY craft.conf /etc/httpd/conf.d
COPY httpd.conf /etc/httpd/conf

ENTRYPOINT /usr/sbin/php-fpm && \
           /usr/sbin/httpd -D FOREGROUND
