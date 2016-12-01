build:
	docker build -t rcarmo/alpine-python:2.7-armhf 2.7
	docker build -t rcarmo/alpine-python:2.7-armhf-onbuild 2.7/onbuild
	docker build -t rcarmo/alpine-python:3.5-armhf 3.5
	docker build -t rcarmo/alpine-python:3.5-armhf-onbuild 3.5/onbuild
	docker tag rcarmo/alpine-python:2.7-armhf rcarmo/alpine-python:2.7.12-armhf
	docker tag rcarmo/alpine-python:3.5-armhf rcarmo/alpine-python:3.5.2-armhf
	docker tag rcarmo/alpine-python:3.5-armhf rcarmo/alpine-python:armhf-latest

push:
	docker push rcarmo/alpine-python
