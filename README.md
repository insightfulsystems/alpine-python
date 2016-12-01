# alpine-python (`armhf`)

[![Docker Stars](https://img.shields.io/docker/stars/rcarmo/alpine-python.svg)](https://hub.docker.com/r/rcarmo/alpine-python)
[![Docker Pulls](https://img.shields.io/docker/pulls/rcarmo/alpine-python.svg)](https://hub.docker.com/r/rcarmo/alpine-python)
[![](https://images.microbadger.com/badges/image/rcarmo/alpine-python.svg)](https://microbadger.com/images/rcarmo/alpine-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/rcarmo/alpine-python.svg)](https://microbadger.com/images/rcarmo/alpine-python "Get your own version badge on microbadger.com")

A small Python Docker image based on [Alpine Linux](http://alpinelinux.org/), inspired by [jfloff's original work](https://github.com/jfloff/alpine-python) but updated for Python 3.5.2 and 2016 builds of Alpine. The Python 3.5.2 image is only 244 MB and includes `python3-dev`.


## Supported tags
* **2.7-armhf ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/2.7/Dockerfile))**
* **2.7-armhf-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/2.7/onbuild/Dockerfile))**
* **3.5-armhf ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/3.5/Dockerfile))**
* **3.5-armhf-onbuild ([Dockerfile](https://github.com/rcarmo/alpine-python/blob/armhf/3.5/onbuild/Dockerfile))**

**NOTE:** `onbuild` images install the `requirements.txt` of your project from the get go. This allows you to cache your requirements right in the build. _Make sure you are in the same directory of your `requirements.txt` file_.

## Current Versions (`armhf`)

When last built on December 1, 2016 against Alpine 3.4, the images contained the following minor/patch Python versions:

* Python 2.7.12
* Python 3.5.2

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

Here's a dump of the `apk` output for each version, currently built against Alpine 3.4:

### 2.7

```
(1/35) Installing ncurses-terminfo-base (6.0-r7)
(2/35) Installing ncurses-terminfo (6.0-r7)
(3/35) Installing ncurses-libs (6.0-r7)
(4/35) Installing readline (6.3.008-r4)
(5/35) Installing bash (4.3.42-r4)
(6/35) Installing binutils-libs (2.26-r0)
(7/35) Installing binutils (2.26-r0)
(8/35) Installing gmp (6.1.0-r0)
(9/35) Installing isl (0.14.1-r0)
(10/35) Installing libgomp (5.3.0-r0)
(11/35) Installing libatomic (5.3.0-r0)
(12/35) Installing pkgconf (0.9.12-r0)
(13/35) Installing pkgconfig (0.25-r1)
(14/35) Installing libgcc (5.3.0-r0)
(15/35) Installing mpfr3 (3.1.2-r0)
(16/35) Installing mpc1 (1.0.3-r0)
(17/35) Installing libstdc++ (5.3.0-r0)
(18/35) Installing gcc (5.3.0-r0)
(19/35) Installing make (4.1-r1)
(20/35) Installing musl-dev (1.1.14-r14)
(21/35) Installing libc-dev (0.7-r0)
(22/35) Installing fortify-headers (0.8-r0)
(23/35) Installing g++ (5.3.0-r0)
(24/35) Installing build-base (0.4-r1)
(25/35) Installing expat (2.1.1-r2)
(26/35) Installing pcre (8.38-r1)
(27/35) Installing git (2.8.3-r0)
(28/35) Installing libbz2 (1.0.6-r5)
(29/35) Installing libffi (3.2.1-r2)
(30/35) Installing gdbm (1.11-r1)
(31/35) Installing sqlite-libs (3.13.0-r0)
(32/35) Installing python (2.7.12-r0)
(33/35) Installing py-setuptools (20.8.0-r0)
(34/35) Installing py-pip (8.1.2-r0)
(35/35) Installing python-dev (2.7.12-r0)
```

### 3.5

```
(1/34) Installing ncurses-terminfo-base (6.0-r7)
(2/34) Installing ncurses-terminfo (6.0-r7)
(3/34) Installing ncurses-libs (6.0-r7)
(4/34) Installing readline (6.3.008-r4)
(5/34) Installing bash (4.3.42-r4)
Executing bash-4.3.42-r4.post-install
(6/34) Installing binutils-libs (2.26-r0)
(7/34) Installing binutils (2.26-r0)
(8/34) Installing gmp (6.1.0-r0)
(9/34) Installing isl (0.14.1-r0)
(10/34) Installing libgomp (5.3.0-r0)
(11/34) Installing libatomic (5.3.0-r0)
(12/34) Installing pkgconf (0.9.12-r0)
(13/34) Installing pkgconfig (0.25-r1)
(14/34) Installing libgcc (5.3.0-r0)
(15/34) Installing mpfr3 (3.1.2-r0)
(16/34) Installing mpc1 (1.0.3-r0)
(17/34) Installing libstdc++ (5.3.0-r0)
(18/34) Installing gcc (5.3.0-r0)
(19/34) Installing make (4.1-r1)
(20/34) Installing musl-dev (1.1.14-r14)
(21/34) Installing libc-dev (0.7-r0)
(22/34) Installing fortify-headers (0.8-r0)
(23/34) Installing g++ (5.3.0-r0)
(24/34) Installing build-base (0.4-r1)
(25/34) Installing expat (2.1.1-r2)
(26/34) Installing pcre (8.38-r1)
(27/34) Installing git (2.8.3-r0)
(28/34) Installing libbz2 (1.0.6-r5)
(29/34) Installing libffi (3.2.1-r2)
(30/34) Installing gdbm (1.11-r1)
(31/34) Installing xz-libs (5.2.2-r1)
(32/34) Installing sqlite-libs (3.13.0-r0)
(33/34) Installing python3 (3.5.2-r1)
(34/34) Installing python3-dev (3.5.2-r1)
```

`pip` is upgraded to 9.0.1 in both cases.

## License
The code in this repository, unless otherwise noted, is MIT licensed. See the `LICENSE` file in this repository.

## Credits
Again, as outlined above, this is based on [jfloff's work](https://github.com/jfloff/alpine-python), with minor tweaks and updates.
