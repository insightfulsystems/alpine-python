FROM alpine:edge

MAINTAINER Rui Carmo https://github.com/rcarmo

# Adds testing package to repositories
# Install needed packages. Notes:
#   * build-base: used so we include the basic development packages (gcc)
#   * python-dev: are used for gevent e.g.
#   * bash: so we can access /bin/bash
RUN apk add --update \
              ca-certificates \
              musl \
              build-base \
              python3 \
              python3-dev \
              bash \
              git \
              gfortran \
              lapack-dev \
              libxml2-dev \
              libxslt-dev \
              jpeg-dev \
  && pip3.6 install --upgrade pip \
  && rm /var/cache/apk/*

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
  && ln -sf easy_install-3.6 easy_install \
  && ln -sf idle3.6 idle \
  && ln -sf pydoc3.6 pydoc \
  && ln -sf python3.6 python \
  && ln -sf python-config3.6 python-config \
  && ln -sf pip3.6 pip \
  && ln -sf /usr/include/locale.h /usr/include/xlocale.h

# since we will be "always" mounting the volume, we can set this up
CMD python
