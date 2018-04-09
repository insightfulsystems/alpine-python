IMAGE_NAME?=insightful/alpine-python

build:
	docker build -t $(IMAGE_NAME):2.7 2.7
	docker build -t $(IMAGE_NAME):2.7-onbuild 2.7/onbuild
	docker build -t $(IMAGE_NAME):3.5 3.5
	docker build -t $(IMAGE_NAME):3.5-onbuild 3.5/onbuild
	docker build -t $(IMAGE_NAME):3.6 3.6
	docker build -t $(IMAGE_NAME):3.6-onbuild 3.6/onbuild
	docker tag $(IMAGE_NAME):2.7 $(IMAGE_NAME):2.7.13
	docker tag $(IMAGE_NAME):3.5 $(IMAGE_NAME):3.5.2
	docker tag $(IMAGE_NAME):3.6 $(IMAGE_NAME):3.6.1
	docker tag $(IMAGE_NAME):3.6 $(IMAGE_NAME):latest

push:
	docker push $(IMAGE_NAME)
