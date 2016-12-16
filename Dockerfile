FROM postgres:9.6.1-alpine

MAINTAINER Jack A Ross <jack.ross@technekes.com>

RUN set -ex \
  \
  && apk add --update --no-cache --virtual .fetch-deps \
    ca-certificates \
    openssl \
    unzip \
    wget \
  \
  && apk add --update --no-cache --virtual .build-deps \
    freetds-dev \
    gcc \
    libc-dev \
    # libedit-dev \
    # libxml2-dev \
    # libxslt-dev \
    make \
    # openssl-dev \
  \
  && apk add --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --virtual .build-deps \
    postgresql-dev \
  \
  && apk add --update --no-cache --virtual .run_deps \
    freetds \
  \
  && rm -rf /usr/local/include \
  && ln -s /usr/include/ /usr/local/include

RUN set -ex \
  \
  && cd /tmp \
  && wget -O "tds_fdw.zip" "https://github.com/GeoffMontee/tds_fdw/archive/master.zip" \
  && unzip tds_fdw.zip \
  && cd tds_fdw-master \
  \
  && make USE_PGXS=1 \
  && make USE_PGXS=1 install \
  \
  && apk del .fetch-deps .build-deps \
  \
  && rm -rf /tmp/tds_fdw*
