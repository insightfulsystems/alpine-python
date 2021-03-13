ARG BASE
FROM ${BASE}

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
              py3-pip \
              bash \
              git \
              gfortran \
              lapack-dev \
              libxml2-dev \
              libxslt-dev \
              jpeg-dev \
 && pip install --upgrade pip \
 && rm /var/cache/apk/*

# make us compatible with manylinux wheels and create some useful symlinks that are expected to exist
RUN echo "manylinux1_compatible = True" > /usr/lib/python3.8/_manylinux.py \
 && cd /usr/bin \
 && ln -sf easy_install-3.8 easy_install \
 && ln -sf idle3.8 idle \
 && ln -sf pydoc3.8 pydoc \
 && ln -sf python3.8 python \
 && ln -sf python-config3.8 python-config \
 && ln -sf pip3.8 pip \
 && ln -sf /usr/include/locale.h /usr/include/xlocale.h

# since we will be "always" mounting the volume, we can set this up
CMD python

ARG VCS_REF
ARG VCS_URL
ARG BUILD_DATE
LABEL org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url=${VCS_URL} \
      org.label-schema.build-date=${BUILD_DATE}
