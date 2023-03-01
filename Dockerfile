FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y sqlite3 postgresql-client openssl curl unzip cron mysql-client wget lsb-release gnupg
#RUN wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb
#RUN dpkg -i mysql-apt-config_0.8.16-1_all.deb
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
RUN echo "ad125f01bada12a1ba2f9986a21c59d2cccbe8d584e7f55079ecbeb7f43a4da4 mariadb_repo_setup" sha256sum -c -
RUN chmod +x mariadb_repo_setup
RUN ./mariadb_repo_setup --mariadb-server-version="mariadb-10.6"
RUN apt-get update -y
RUN apt install mariadb-client
RUN curl https://rclone.org/install.sh | bash

# create the app directory
WORKDIR /app

# copy project folder
COPY . ./

# copy mysqldump binary
# COPY --from=linuxserver/mariadb:latest /usr/bin/mysqldump /usr/bin/mysqldump

# fix permissions
RUN ["chmod", "+x", "scripts/backup.sh", "scripts/entrypoint.sh"]

# volume for rclone config
VOLUME ["/root/.config/rclone"]

# entrypoint
ENTRYPOINT ["/bin/sh", "scripts/backup.sh"]
