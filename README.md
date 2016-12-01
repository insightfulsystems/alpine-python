# alpine-python (now in `x64` and `armhf` flavors)

[![Docker Stars](https://img.shields.io/docker/stars/rcarmo/alpine-python.svg)](https://hub.docker.com/r/rcarmo/alpine-python)
[![Docker Pulls](https://img.shields.io/docker/pulls/rcarmo/alpine-python.svg)](https://hub.docker.com/r/rcarmo/alpine-python)
[![](https://images.microbadger.com/badges/image/rcarmo/alpine-python.svg)](https://microbadger.com/images/rcarmo/alpine-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/rcarmo/alpine-python.svg)](https://microbadger.com/images/rcarmo/alpine-python "Get your own version badge on microbadger.com")

A small Python Docker image based on [Alpine Linux](http://alpinelinux.org/), inspired by [jfloff's original work](https://github.com/jfloff/alpine-python) but updated for Python 3.5.2 and 2016 builds of Alpine. The Python 3.5.2 image is only 244 MB and includes `python3-dev`.

## Supported tags

`latest` is not guaranteed to give you the version (or architecture) you want, so please use the following tags:

* **2.7 ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/master/2.7/Dockerfile))**
* **2.7-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/master/2.7/onbuild/Dockerfile))**
* **2.7-armhf ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/2.7/Dockerfile))**
* **2.7-armhf-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/2.7/onbuild/Dockerfile))**
* **3.5 ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/master/3.5/Dockerfile))**
* **3.5-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/master/3.5/onbuild/Dockerfile))**
* **3.5-armhf ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/3.5/Dockerfile))**
* **3.5-armhf-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/3.5/onbuild/Dockerfile))**

**NOTE:** `onbuild` images install the `requirements.txt` of your project from the get go. This allows you to cache your requirements right in the build. _Make sure you are in the same directory of your `requirements.txt` file_.

Also, sometime in the near future the 'bare' versions will be deprecated and I will be adding an explicit `x64` tag.

## Current Versions

When last built on December 1st, 2016 against Alpine 3.4, the images contained the following minor/patch Python versions:

* Python 2.7.12
* Python 3.5.2

For details on the `armmf` versions (which I always try to keep in sync with the `x64` ones, check the `armhf` branch.

## Why?

Well, first off, because I needed an easy way to run and deploy a Linux build of Python 3.5, which, given the current state of affairs in Python land, is not yet my go to version and hence only occasionally useful for me. The [original builds by jfloff](https://github.com/jfloff/alpine-python) had everything needed for the most common Python projects - including `python3-dev` (which is not common in most minimal alpine Python packages), plus the great `-onbuild` variants, which made it a lot easier to build ready-to-deploy apps, so it was perfect for getting 3.5 going without disrupting my existing environments.

The default docker Python images are too [big](https://github.com/docker-library/python/issues/45), much larger than they need to be. [Alpine-based](https://github.com/gliderlabs/docker-alpine) images are just _way_ smaller and faster to deploy:

```
REPOSITORY                TAG           VIRTUAL SIZE
rcarmo/alpine-python      2.7           223 MB
rcarmo/alpine-python      3.5           244.8 MB
jfloff/alpine-python      3.4           225.7 MB
python                    3.4           685.5 MB
python                    3.4-slim      215.1 MB
```

We actually get around the same size as `python:3.4-slim` *but* with `python3-dev` installed (that's around 55MB).

## Usage
This image runs `python` command on `docker run`. You can either specify your own command, e.g:
```shell
docker run --rm -ti rcarmo/alpine-python python hello.py
```

Or extend this image using your custom `Dockerfile`, e.g:
```dockerfile
FROM rcarmo/alpine-python:3.5-onbuild

# for a flask server
EXPOSE 5000
CMD python manage.py runserver
```

Dont' forget to build _your_ image:
```shell
docker build --rm=true -t rcarmo/app .
```

You can also access `bash` inside the container:
```shell
docker run --rm -ti rcarmo/alpine-python /bin/bash
```

Another option is to build an extended `Dockerfile` version (like shown above), and mount your application inside the container:
```shell
docker run --rm -v "$(pwd)":/home/app -w /home/app -p 5000:5000 -ti rcarmo/app
```

## Details
* Installs `python-dev` allowing the use of more advanced packages such as `gevent`
* Installs `bash` allowing interaction with the container
* Just like the main `python` docker image, it creates useful symlinks that are expected to exist, e.g. `python3.5` > `python`, `pip2.7` > `pip`, etc.)
* Added `testing` repository to Alpine's `/etc/apk/repositories` file

## Packages installed

Here's a dump of the `apk` output for the `x64` versions, currently built against Alpine 3.4:

### 2.7

```
(1/40) Upgrading musl (1.1.14-r12 -> 1.1.14-r14)
(2/40) Installing ncurses-terminfo-base (6.0-r7)
(3/40) Installing ncurses-terminfo (6.0-r7)
(4/40) Installing ncurses-libs (6.0-r7)
(5/40) Installing readline (6.3.008-r4)
(6/40) Installing bash (4.3.42-r4)
(7/40) Installing binutils-libs (2.26-r0)
(8/40) Installing binutils (2.26-r0)
(9/40) Installing gmp (6.1.0-r0)
(10/40) Installing isl (0.14.1-r0)
(11/40) Installing libgomp (5.3.0-r0)
(12/40) Installing libatomic (5.3.0-r0)
(13/40) Installing libgcc (5.3.0-r0)
(14/40) Installing pkgconf (0.9.12-r0)
(15/40) Installing pkgconfig (0.25-r1)
(16/40) Installing mpfr3 (3.1.2-r0)
(17/40) Installing mpc1 (1.0.3-r0)
(18/40) Installing libstdc++ (5.3.0-r0)
(19/40) Installing gcc (5.3.0-r0)
(20/40) Installing make (4.1-r1)
(21/40) Installing musl-dev (1.1.14-r14)
(22/40) Installing libc-dev (0.7-r0)
(23/40) Installing fortify-headers (0.8-r0)
(24/40) Installing g++ (5.3.0-r0)
(25/40) Installing build-base (0.4-r1)
(26/40) Installing ca-certificates (20160104-r4)
(27/40) Installing libssh2 (1.7.0-r0)
(28/40) Installing libcurl (7.51.0-r0)
(29/40) Installing expat (2.1.1-r1)
(30/40) Installing pcre (8.38-r1)
(31/40) Installing git (2.8.3-r0)
(32/40) Upgrading musl-utils (1.1.14-r12 -> 1.1.14-r14)
(33/40) Installing libbz2 (1.0.6-r5)
(34/40) Installing libffi (3.2.1-r2)
(35/40) Installing gdbm (1.11-r1)
(36/40) Installing sqlite-libs (3.13.0-r0)
(37/40) Installing python (2.7.12-r0)
(38/40) Installing py-setuptools (20.8.0-r0)
(39/40) Installing py-pip (8.1.2-r0)
(40/40) Installing python-dev (2.7.12-r0)
```

### 3.5

```
(1/39) Upgrading musl (1.1.14-r12 -> 1.1.14-r14)
(2/39) Installing ncurses-terminfo-base (6.0-r7)
(3/39) Installing ncurses-terminfo (6.0-r7)
(4/39) Installing ncurses-libs (6.0-r7)
(5/39) Installing readline (6.3.008-r4)
(6/39) Installing bash (4.3.42-r4)
(7/39) Installing binutils-libs (2.26-r0)
(8/39) Installing binutils (2.26-r0)
(9/39) Installing gmp (6.1.0-r0)
(10/39) Installing isl (0.14.1-r0)
(11/39) Installing libgomp (5.3.0-r0)
(12/39) Installing libatomic (5.3.0-r0)
(13/39) Installing libgcc (5.3.0-r0)
(14/39) Installing pkgconf (0.9.12-r0)
(15/39) Installing pkgconfig (0.25-r1)
(16/39) Installing mpfr3 (3.1.2-r0)
(17/39) Installing mpc1 (1.0.3-r0)
(18/39) Installing libstdc++ (5.3.0-r0)
(19/39) Installing gcc (5.3.0-r0)
(20/39) Installing make (4.1-r1)
(21/39) Installing musl-dev (1.1.14-r14)
(22/39) Installing libc-dev (0.7-r0)
(23/39) Installing fortify-headers (0.8-r0)
(24/39) Installing g++ (5.3.0-r0)
(25/39) Installing build-base (0.4-r1)
(26/39) Installing ca-certificates (20160104-r4)
(27/39) Installing libssh2 (1.7.0-r0)
(28/39) Installing libcurl (7.51.0-r0)
(29/39) Installing expat (2.1.1-r1)
(30/39) Installing pcre (8.38-r1)
(31/39) Installing git (2.8.3-r0)
(32/39) Upgrading musl-utils (1.1.14-r12 -> 1.1.14-r14)
(33/39) Installing libbz2 (1.0.6-r5)
(34/39) Installing libffi (3.2.1-r2)
(35/39) Installing gdbm (1.11-r1)
(36/39) Installing xz-libs (5.2.2-r1)
(37/39) Installing sqlite-libs (3.13.0-r0)
(38/39) Installing python3 (3.5.2-r1)
(39/39) Installing python3-dev (3.5.2-r1)
```

`pip` is upgraded to 9.0.1 in both cases.

## License
The code in this repository, unless otherwise noted, is MIT licensed. See the `LICENSE` file in this repository.

## Credits
Again, as outlined above, this is based on [jfloff's work](https://github.com/jfloff/alpine-python), with minor tweaks and updates.
