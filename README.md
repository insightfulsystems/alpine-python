# alpine-python (now in `x64` and `armhf` flavors)

[![Docker Stars](https://img.shields.io/docker/stars/insightful/alpine-python.svg)](https://hub.docker.com/r/insightful/alpine-python)
[![Docker Pulls](https://img.shields.io/docker/pulls/insightful/alpine-python.svg)](https://hub.docker.com/r/insightful/alpine-python)
[![](https://images.microbadger.com/badges/image/insightful/alpine-python.svg)](https://microbadger.com/images/insightful/alpine-python "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/insightful/alpine-python.svg)](https://microbadger.com/images/insightful/alpine-python "Get your own version badge on microbadger.com")
[![Build Status](https://travis-ci.org/insightfulsystems/alpine-python.svg?branch=master)](https://travis-ci.org/insightfulsystems/alpine-python)

A small Python Docker image based on [Alpine Linux](http://alpinelinux.org/), inspired by [jfloff's original work](https://github.com/jfloff/alpine-python) but updated for Python 3.6/2.7 and 2019 builds of Alpine. The Python 3 image is only 285 MB and includes `python3-dev`, and all images include support for `manylinux` wheels (where possible)

## Supported tags

`latest` is not guaranteed to give you the version (or architecture) you want, so please use the following tags:

* **2.7 ([Dockerfile](https://github.com/insightfulsystems/alpine-python/blob/master/2.7/Dockerfile))**
* **2.7-armhf ([Dockerfile](https://github.com/insightfulsystems/alpine-python/blob/armhf/2.7/Dockerfile))**
* **3.6 ([Dockerfile](https://github.com/insightfulsystems/alpine-python/blob/master/3.6/Dockerfile))**

**NOTE:** `onbuild` images install the `requirements.txt` of your project from the get go. This allows you to cache your requirements right in the build. _Make sure you are in the same directory of your `requirements.txt` file_.

Also, sometime in the near future the 'bare' versions will be deprecated and I will be adding an explicit `x64` tag.

## Current Versions

For details on the `armhf` versions (which I always try to keep in sync with the `x64` ones, check the `armhf` branch.

## Why?

Well, first off, because I needed an easy way to run and deploy a Linux build of Python 3.5, which, given the current state of affairs in Python land, is not yet my go to version and hence only occasionally useful for me. The [original builds by jfloff](https://github.com/jfloff/alpine-python) had everything needed for the most common Python projects - including `python3-dev` (which is not common in most minimal alpine Python packages), plus the great `-onbuild` variants, which made it a lot easier to build ready-to-deploy apps, so it was perfect for getting 3.5 going without disrupting my existing environments.

The default docker Python images are too [big](https://github.com/docker-library/python/issues/45), much larger than they need to be. [Alpine-based](https://github.com/gliderlabs/docker-alpine) images are just _way_ smaller and faster to deploy:

```
REPOSITORY                TAG           VIRTUAL SIZE
insightful/alpine-python   3.6-onbuild   285 MB
insightful/alpine-python   3.6           285 MB
insightful/alpine-python   2.7-onbuild   280 MB
insightful/alpine-python   2.7           280 MB
jfloff/alpine-python       3.4           225.7 MB
python                     3.4           685.5 MB
python                     3.4-slim      215.1 MB
```

We actually get around the same size as `python:3.4-slim` *but* with `python3-dev` installed (that's around 55MB).

## Usage
This image runs `python` command on `docker run`. You can either specify your own command, e.g:
```shell
docker run --rm -ti insightful/alpine-python python hello.py
```

Or extend this image using your custom `Dockerfile`, e.g:
```dockerfile
FROM insightful/alpine-python:3.6-onbuild

# for a flask server
EXPOSE 5000
CMD python manage.py runserver
```

Dont' forget to build _your_ image:
```shell
docker build --rm=true -t insightful/app .
```

You can also access `bash` inside the container:
```shell
docker run --rm -ti insightful/alpine-python /bin/bash
```

Another option is to build an extended `Dockerfile` version (like shown above), and mount your application inside the container:
```shell
docker run --rm -v "$(pwd)":/home/app -w /home/app -p 5000:5000 -ti insightful/app
```

## Details
* Installs `python-dev` allowing the use of more advanced packages such as `gevent`
* Installs `bash` allowing interaction with the container
* Just like the main `python` docker image, it creates useful symlinks that are expected to exist, e.g. `python3.6` > `python`, `pip2.7` > `pip`, etc.)
* Added `testing` repository to Alpine's `/etc/apk/repositories` file
* `pip` is upgraded to 9.0.1 in all cases.

## License
The code in this repository, unless otherwise noted, is MIT licensed. See the `LICENSE` file in this repository.

## Credits
Again, as outlined above, this is based on [jfloff's work](https://github.com/jfloff/alpine-python), with minor tweaks and updates.
