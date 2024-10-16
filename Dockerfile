# With Python 3.12.4 on Alpine 3.20, s3cmd 2.4.0 fails with an AttributeError.
# See ITSE-1440 for details.
FROM python:3.12.3-alpine

# Current version of s3cmd is in edge/testing repo
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

# Install everything via repo because repo & pip installs can break things
RUN apk update \
    && apk add --no-cache \
    bash \
    postgresql14-client \
    py3-magic \
    py3-dateutil

COPY application/ /data/
WORKDIR /data

ADD coscli-v1.0.1-linux-amd64 /usr/local/bin/cos
RUN chmod +x /usr/local/bin/cos

CMD ["./entrypoint.sh"]
