FROM alpinelib/base:edge
MAINTAINER Ekozan

ENV MYSQL_VERSION 10.1.9-r2

RUN apk-install bash ca-certificates mysql mysql-client

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /
COPY files /

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306
CMD ["mysqld"]
