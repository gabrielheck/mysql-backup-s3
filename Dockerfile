FROM ubuntu:latest

ENV MYSQLDUMP_OPTIONS --quick --no-create-db --add-drop-table --add-locks --allow-keywords --quote-names --disable-keys --single-transaction --create-options --comments --net_buffer_length=16384
ENV MYSQLDUMP_DATABASE **None**
ENV MYSQL_HOST **None**
ENV MYSQL_PORT 3306
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV S3_PREFIX 'backup'
ENV S3_FILENAME **None**
ENV MULTI_DATABASES no
ENV BACKUP_TIME 02:00

# install mysqldump, pip, awscli
RUN apt-get update && \
    apt-get install -y mysql-client python3 python3-pip && \
    pip3 install awscli && \
    apt-get autoremove -y && \
    apt-get remove -y python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD run.sh backup.sh /
RUN chmod +x /run.sh /backup.sh

CMD sleep $(( ($(date -d "$BACKUP_TIME" +%s) - $(date +%s) + 86400) % 86400 )) && sh /run.sh

