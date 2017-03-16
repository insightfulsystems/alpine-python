build:
	docker build -t rcarmo/alpine-python:2.7 2.7
	docker build -t rcarmo/alpine-python:2.7-onbuild 2.7/onbuild
	docker build -t rcarmo/alpine-python:3.5 3.5
	docker build -t rcarmo/alpine-python:3.5-onbuild 3.5/onbuild
	docker build -t rcarmo/alpine-python:3.6 3.6
	docker build -t rcarmo/alpine-python:3.6-onbuild 3.6/onbuild
	docker tag rcarmo/alpine-python:2.7 rcarmo/alpine-python:2.7.13
	docker tag rcarmo/alpine-python:3.5 rcarmo/alpine-python:3.5.2
	docker tag rcarmo/alpine-python:3.6 rcarmo/alpine-python:3.6.0
	docker tag rcarmo/alpine-python:3.6 rcarmo/alpine-python:latest

push:
	docker push rcarmo/alpine-python
