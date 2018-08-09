FROM alpine:3.8

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
              bash \
              git \
              python \
              python-dev \
              py-pip \
              gfortran \
              lapack-dev \
              libxml2-dev \
              libxslt-dev \
              jpeg-dev \
 && pip install --upgrade pip \
 && rm /var/cache/apk/*

# make us compatible with manylinux wheels and create some useful symlinks that are expected to exist
RUN echo "manylinux1_compatible = True" > /usr/lib/python2.7/_manylinux.py \
 && cd /usr/bin \
 && ln -sf easy_install-2.7 easy_install \
 && ln -sf python2.7 python \
 && ln -sf python2.7-config python-config \
 && ln -sf pip2.7 pip \
 && ln -sf /usr/include/locale.h /usr/include/xlocale.h

# since we will be "always" mounting the volume, we can set this up
CMD python

ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url=${VCS_URL} \
      org.label-schema.build-date=${BUILD_DATE}
