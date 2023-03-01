FROM debian:latest

RUN apt-get update -y
RUN apt-get install -y sqlite3 postgresql-client tzdata openssl curl unzip crontab crond
RUN curl https://rclone.org/install.sh | bash

# create the app directory
WORKDIR /app

# copy project folder
COPY . ./

# copy mysqldump binary
COPY --from=linuxserver/mariadb:latest /usr/bin/mysqldump /usr/bin/mysqldump

# fix permissions
RUN ["chmod", "+x", "scripts/backup.sh", "scripts/entrypoint.sh"]

# volume for rclone config
VOLUME ["/root/.config/rclone"]

# entrypoint
ENTRYPOINT ["/bin/sh", "scripts/entrypoint.sh"]
