FROM centos:latest
RUN yum update -y && \
        yum install httpd wget unzip -y && \
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
        dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
        dnf module enable php:remi-7.2 -y && \
        dnf install php php-cli php-cgi php-curl php-json php-xml php-intl php-common php-gd php-mysqlnd php-soap php-pdo php-common \
        php-mcrypt php-mbstring php-zip -y && \
        mkdir /run/php-fpm && touch /run/php-fpm/www.sock && \
        chmod -R 777 /run/php-fpm/www.sock && \
        chown -R apache:apache /run/php-fpm/www.sock


WORKDIR /var/www/

RUN wget https://download.craftcdn.com/craft/2.6/2.6.2993/Craft-2.6.2993.zip && \
        unzip Craft-2.6.2993.zip && \
        mv /var/www/public/* /var/www/html/ && \
        mv /var/www/html/htaccess /var/www/html/.htaccess && \
        rmdir /var/www/public


COPY craft.conf /etc/httpd/conf.d/

ADD db.php /var/www/craft/config/

RUN chown -R apache:apache \
        /var/www/craft/app/ \
        /var/www/craft/config/ \
        /var/www/craft/storage/

ENTRYPOINT /usr/sbin/php-fpm && \
        /usr/sbin/httpd -D FOREGROUND

