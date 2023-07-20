FROM alpine:edge

# install required packages
RUN apk --no-cache -U add \
    fuse \
    mariadb-client \
    ca-certificates \
    postgresql-client \
    sqlite \
    tzdata \
    libffi-dev \
    musl-dev \
    libressl-dev \
    gcc



# create the app directory
WORKDIR /app

# copy project folder
COPY . ./

# copy rclone binary
COPY --from=rclone/rclone:latest /usr/local/bin/rclone /usr/bin/rclone

# copy mysqldump binary
# COPY --from=linuxserver/mariadb:alpine /usr/bin/mysqldump /usr/bin/mysqldump

# volume for rclone config
VOLUME ["/root/.config/rclone"]

# entrypoint
ENTRYPOINT ["/app/src/entrypoint.sh"]

# cmd
CMD ["crond", "-l", "2", "-f"]
